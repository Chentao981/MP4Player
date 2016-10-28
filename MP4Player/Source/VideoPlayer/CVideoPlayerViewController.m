//
//  CVideoPlayerViewController.m
//  MP4Player
//
//  Created by Chentao on 2016/10/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CVideoPlayerViewController.h"
#import "CVideoPlayer.h"
#import "CVideoFileInfo.h"

#define VideoFileInfoDirectory @"videoinfo"

@interface CVideoPlayerViewController ()<CVideoPlayerDelegate>

@property(nonatomic,strong)CVideoPlayer *videoPlayer;

@property(nonatomic,strong)CVideoFileInfo *videoFileInfo;

@end

@implementation CVideoPlayerViewController {
    BOOL firstLoad;
    BOOL playState; // YES 播放 ; NO 暂停
    
    NSThread *saveVideoFileInfoThread;
}

#pragma mark - ViewController Life

- (void)loadView {
    _videoPlayer = [[CVideoPlayer alloc] init];
    _videoPlayer.delegate = self;
    self.view = _videoPlayer;
}

- (CVideoPlayer *)videoPlayer {
    return (CVideoPlayer *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self activeAudioSession];
    [self addNotification];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!firstLoad) {
        firstLoad = YES;
        [self loadVideoFile];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videoPlayer pause];
}

- (void)setTitle:(NSString *)title {
    self.videoPlayer.title = title;
}

-(void)setVideoFile:(CFile *)videoFile{
    _videoFile=videoFile;
    
    self.videoFileInfo=[[CVideoFileInfo alloc]init];
    self.videoFileInfo.filePath=_videoFile.filePath;
    self.videoFileInfo.fileName=_videoFile.fileName;
    self.videoFileInfo.videoInfoFileName=[_videoFile.filePath getMD5];
}


//激活AVAudioSession
-(void)activeAudioSession{
    DEBUG_LOG(@"VP设置激活AudioSession");
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setActive:YES error:&error];
    if (error) {
        DEBUG_LOG(@"VP激活AVAudioSession失败：%@",error);
    }
}


#pragma mark-addNotification
- (void)addNotification {
    
    //耳机拔出处理
    [[NSNotificationCenter defaultCenter] addObserver:self
                             selector:@selector(headphonePulloutHandler:)
                                 name:kCNotificationApplicationHeadphonePullout
                               object:nil];
    
    //语音打断处理
    [[NSNotificationCenter defaultCenter] addObserver:self
                             selector:@selector(audioSessionBeginInterruptionHandler:)
                                 name:kCNotificationApplicationAudioSessionBeginInterruption
                               object:nil];
    
    //切换到前台处理
    [[NSNotificationCenter defaultCenter] addObserver:self
                             selector:@selector(appEnteredForeground:)
                                 name:UIApplicationWillEnterForegroundNotification
                               object:nil];
    
    //切换到后台处理
    [[NSNotificationCenter defaultCenter] addObserver:self
                             selector:@selector(appEnteredBackground:)
                                 name:UIApplicationDidEnterBackgroundNotification
                               object:nil];
}

- (void)appEnteredForeground:(NSNotification *)notification {
    [self activeAudioSession];
    if (playState) {
        [self.videoPlayer play];
    }
}

- (void)appEnteredBackground:(NSNotification *)notification {
    playState =self.videoPlayer.isPlay;
    [self.videoPlayer pause];
}

- (void)audioSessionBeginInterruptionHandler:(NSNotification *)notification {
    [self.videoPlayer pause];
}

- (void)headphonePulloutHandler:(NSNotification *)notification {
    DEBUG_LOG(@"VP拔出耳机  暂停播放");
    [self.videoPlayer pause];
}

#pragma mark-removeNotification
- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Init VideoData

- (void)loadVideoFile {
    self.title = self.videoFile.fileName;
    //判断.mp4文件是否存在
    if ([HYFileManager isExistsAtPath:self.videoFile.filePath]) {
        DEBUG_LOG(@"mp4文件存在");
        NSURL *url = [[NSURL alloc] initFileURLWithPath:self.videoFile.filePath];
        [self.videoPlayer loadVideoWithURL:url];
    }else{
        __weak __typeof(self) weakSelf = self;
        [[CHUDManagement sharedInstance]showFailureHUDWithMessage:@"文件不存在！"
                                                       completion:^(CHUD * _Nullable hud, UIView * _Nullable inView) {
            [weakSelf videoPlayerControllerBack];
        }];
    }
}





#pragma mark -CVideoPlayerDelegate
- (void)videoPlayerWillLoadAsset:(CVideoPlayer *)videoPlayer {
    [videoPlayer showVideoLoading];
}

- (void)videoPlayerAssetOnReady:(CVideoPlayer *)videoPlayer {
    self.videoFileInfo.duration=CMTimeGetSeconds(videoPlayer.playerItemDurationTime);
    
    CVideoFileInfo *videoInfo;
    
    id archiveInfo= [self getVideoFileInfo:self.videoFileInfo];
    
    if ([archiveInfo isMemberOfClass:[CVideoFileInfo class]]) {
        videoInfo=archiveInfo;
    }else{
        videoInfo=nil;
    }
    
    self.videoFileInfo.progress=videoInfo.progress;
    float progress =self.videoFileInfo.progress;
    if (isnan(progress) || progress>1.0) {
        progress = 0;
    }
    [videoPlayer loadToProgress:progress];
}

- (void)videoPlayerLoadToProgressCompletion:(CVideoPlayer *)videoPlayer {
    DEBUG_LOG(@"VP视频seek到指定进度完成");
    [videoPlayer hidenVideoLoading];
    [videoPlayer play];
}

- (void)videoPlayer:(CVideoPlayer *)videoPlayer loadAssetFailed:(NSError *)error {
    __weak __typeof(self) weakSelf = self;
    [[CHUDManagement sharedInstance] showFailureHUDWithMessage:@"视频文件加载失败！"
                                                    completion:^(CHUD * _Nullable hud, UIView * _Nullable inView) {
        [weakSelf videoPlayerControllerBack];
    }];
}

- (void)videoPlayer:(CVideoPlayer *)videoPlayer changeCurrentTime:(Float64)currentTime duration:(Float64)duration {
    float progress = currentTime / duration;
    DEBUG_LOG(@"VP视频播放进度progress:%f",progress);
    self.videoFileInfo.progress=progress;
    
    if (saveVideoFileInfoThread) {
        [saveVideoFileInfoThread cancel];
    }
    saveVideoFileInfoThread=[[NSThread alloc]initWithTarget:self
                                                   selector:@selector(saveVideoFileInfo:)
                                                     object:self.videoFileInfo];
    [saveVideoFileInfoThread start];
}


- (void)videoPlayerOnBack:(CVideoPlayer *)videoPlayer {
    [self videoPlayerControllerBack];
}


-(void)videoPlayerControllerBack{
    CEvent *event=[[CEvent alloc]initWithType:ViewController_ComeBack andData:self];
    [self dispatchEvent:event];
}


#pragma mark- Save Video File Info

- (BOOL)saveVideoFileInfo:(CVideoFileInfo *)file {
    if (file) {
        NSString *archiverDirectory=[[HYFileManager cachesDir] stringByAppendingPathComponent:VideoFileInfoDirectory];
        if (![HYFileManager isExistsAtPath:archiverDirectory]) {
            [HYFileManager createDirectoryAtPath:archiverDirectory];
        }
        NSString *archiverName=file.videoInfoFileName;
        NSString *archiverPath=[archiverDirectory stringByAppendingPathComponent:archiverName];
        BOOL success = [NSKeyedArchiver archiveRootObject:file toFile:archiverPath];
        return success;
    } else {
        return NO;
    }
}

- (CVideoFileInfo *)getVideoFileInfo:(CVideoFileInfo *)file {
    NSString *archiverDirectory=[[HYFileManager cachesDir] stringByAppendingPathComponent:VideoFileInfoDirectory];
    NSString *archiverName=file.videoInfoFileName;
    NSString *archiverPath=[archiverDirectory stringByAppendingPathComponent:archiverName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:archiverPath];
}

- (void)dealloc {
    DEBUG_LOG(@"dealloc");
    if (saveVideoFileInfoThread) {
        [saveVideoFileInfoThread cancel];
        saveVideoFileInfoThread = nil;
    }
    [self removeNotification];
}

@end
