//
//  CPlayerView.m
//  CVideoPlayer
//
//  Created by Chentao on 16/7/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CVideoPlayer.h"

#define PlayerItem_Status_Key @"status"

static void *kStatusObservationContext = &kStatusObservationContext;

static NSString *kRequestKeyPlayState = @"playable";
static NSString *kRequestKeyDuration = @"duration";

@interface CVideoPlayer () <CPlayerControlViewDelegate>

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, readonly) BOOL currentPlayState;

/**
 *  播放速度
 */
@property (nonatomic, assign) float rate;

@end

@implementation CVideoPlayer {
    BOOL isPause;
    CMTime beginTime;
    AVPlayerItemStatus playerItemStatus;
}
@synthesize playerControlView = _playerControlView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.backgroundColor = ColorMake(0x000000);
        [self createSubviews];
    }
    return self;
}

- (void)initData {
    isPause = YES;
    self.rate = 1.0;
}

- (void)createSubviews {
    [self addSubview:self.playerControlView];
}

- (CPlayerControlView *)playerControlView {
    if (!_playerControlView) {
        _playerControlView = [[CPlayerControlView alloc] init];
        _playerControlView.delegate = self;
    }
    return _playerControlView;
}

- (void)setTitle:(NSString *)title {
    self.playerControlView.title = title;
}

- (NSString *)title {
    return self.playerControlView.title;
}

- (BOOL)isPlay {
    return [self currentPlayState];
}

- (void)loadVideoWithURL:(NSURL *)url {
    self.playerControlView.userInteractionEnabled = NO;

    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerWillLoadAsset:)]) {
        [self.delegate videoPlayerWillLoadAsset:self];
    }

    AVURLAsset *videoAsset = [AVURLAsset assetWithURL:url];

    NSArray *requestedKeys = @[kRequestKeyPlayState, kRequestKeyDuration];

    __weak __typeof(self) weakSelf = self;

    [videoAsset loadValuesAsynchronouslyForKeys:requestedKeys
                              completionHandler:^{
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [weakSelf prepareToPlayAsset:videoAsset withKeys:requestedKeys];
                                  });
                              }];
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys {
    for (NSString *key in requestedKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:key error:&error];
        if (keyStatus == AVKeyValueStatusFailed) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:loadAssetFailed:)]) {
                [self.delegate videoPlayer:self loadAssetFailed:error];
            }
            return;
        }
    }

    if (!asset.playable) {
        /* 生成一个错误的描述. */
        NSString *localizedDescription = NSLocalizedString(@"不能播放", @"未知错误不能播放");
        NSString *localizedFailureReason = NSLocalizedString(@"未知错误不能播放", @"不能播放原因");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:localizedDescription, NSLocalizedDescriptionKey, localizedFailureReason, NSLocalizedFailureReasonErrorKey, nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];

        DEBUG_LOG(@"未知错误不能播放");
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:loadAssetFailed:)]) {
            [self.delegate videoPlayer:self loadAssetFailed:assetCannotBePlayedError];
        }
        return;
    }

    [self.playerControlView setTime:0 duration:CMTimeGetSeconds(asset.duration)];

    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:PlayerItem_Status_Key];
        [self removeNotificationListener];
    }

    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];

    [self.playerItem addObserver:self forKeyPath:PlayerItem_Status_Key options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:kStatusObservationContext];
    [self addNotificationListener];

    __weak __typeof(self) weakSelf = self;
    AVPlayer *player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                         queue:dispatch_get_main_queue()
                                    usingBlock:^(CMTime time) {
                                        // NSLog(@"%lld",time.value);
                                        [weakSelf updateProgressView];
                                    }];
    self.player = player;
}

- (void)addNotificationListener {
    /* 去监听当payer已经播放结束，可能要去做一些更新UI的操作*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                             selector:@selector(playerItemDidReachEnd:)
                                 name:AVPlayerItemDidPlayToEndTimeNotification
                               object:self.playerItem];
}

- (void)removeNotificationListener {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                  object:self.playerItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if (context == kStatusObservationContext) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay: {
                self.playerControlView.userInteractionEnabled = YES;

                DEBUG_LOG(@"视频文件已准备好 AVPlayerItemStatusReadyToPlay");
                DEBUG_LOG(@"status:%ld  playerItemStatus:%ld",(long)status,(long)playerItemStatus);
                
                if (playerItemStatus != status) {
                    DEBUG_LOG(@"视频文件已准备好");
                    playerItemStatus = AVPlayerItemStatusReadyToPlay;

                    [self.player pause];
                    [self.playerControlView pause];
                    isPause=YES;
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerAssetOnReady:)]) {
                        [self.delegate videoPlayerAssetOnReady:self];
                    }

                }
                break;
            }
            /* 未知播放状态*/
            case AVPlayerItemStatusUnknown: {
                DEBUG_LOG(@"未知播放状态 AVPlayerItemStatusUnknown");
                playerItemStatus = AVPlayerItemStatusUnknown;
                break;
            }
            case AVPlayerItemStatusFailed: {
                DEBUG_LOG(@"未知错误不能播放 AVPlayerItemStatusFailed");
                playerItemStatus = AVPlayerItemStatusFailed;
                self.playerControlView.userInteractionEnabled = NO;
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:loadAssetFailed:)]) {
                    [self.delegate videoPlayer:self loadAssetFailed:playerItem.error];
                }
                break;
            }
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if (notification.object == self.playerItem) {
        [self seekToProgress:0];
        [self pause];
        [self.playerControlView setTime:0 duration:[self playerItemDurationSeconds]];

        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerDidPlayToEndTime:)]) {
            [self.delegate videoPlayerDidPlayToEndTime:self];
        }
    }
}



- (BOOL)currentPlayState {
    if (0 != self.player.rate) {
        //播放中
        return YES;
    }
    return NO;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)self.layer player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)self.layer setPlayer:player];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);

    if (CGRectGetWidth(self.playerControlView.frame) != viewWidth || CGRectGetHeight(self.playerControlView.frame) != viewHeight) {
        self.playerControlView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
}

- (CMTime)playerItemDurationTime {
    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        return ([self.playerItem duration]);
    }
    return (kCMTimeInvalid);
}

- (Float64)playerItemDurationSeconds {
    return CMTimeGetSeconds([self playerItemDurationTime]);
}

- (CMTime)currentTime {
    return self.player.currentItem.currentTime;
}

- (Float64)currentTimeSeconds {
    return CMTimeGetSeconds([self currentTime]);
}

- (void)updateProgressView {
    Float64 tempCurrentTime = [self currentTimeSeconds];
    Float64 tempPlayerItemDuration = [self playerItemDurationSeconds];
    [self.playerControlView setTime:tempCurrentTime duration:tempPlayerItemDuration];

    if (!isnan(tempCurrentTime / tempPlayerItemDuration)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:changeCurrentTime:duration:)]) {
            [self.delegate videoPlayer:self changeCurrentTime:tempCurrentTime duration:tempPlayerItemDuration];
        }
    }
}

- (float)progress {
    Float64 duration = [self playerItemDurationSeconds];
    if (duration > 0) {
        return [self currentTimeSeconds] / duration;
    }
    return 0;
}

#pragma mark -Play Control

/**
 *  开始播放
 */
- (void)playVideo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerWillCallPlay:)]) {
        [self.delegate videoPlayerWillCallPlay:self];
    }
    
    [self.player play];
    self.player.rate = self.rate;
    DEBUG_LOG(@"VP开始播放视频rate:%f player.rate:%f",self.rate,self.player.rate);
    [self.playerControlView play];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerDidCallPlay:)]) {
        [self.delegate videoPlayerDidCallPlay:self];
    }
}

- (void)play {
    [self playVideo];
    isPause = NO;
}

/**
 *  暂停播放
 */
- (void)pauseVideo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerWillCallPause:)]) {
        [self.delegate videoPlayerWillCallPause:self];
    }
    
    [self.player pause];
    [self.playerControlView pause];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerDidCallPause:)]) {
        [self.delegate videoPlayerDidCallPause:self];
    }
}

- (void)pause {
    [self pauseVideo];
    isPause = YES;
}

/**
 *  跳到指定的时间点
 *
 *  @param time time
 */
- (void)seekToTime:(NSTimeInterval)time {
    if (time < 0) {
        return;
    }

    NSTimeInterval duration = [self playerItemDurationSeconds];
    if (time > duration) {
        return;
    }

    [self seekToProgress:time / duration];
}

/**
 *  跳到指定的进度 ，百分比
 *
 *  @param progress progress
 */
- (void)seekToProgress:(float)progress {
    CMTime time = [self playerItemDurationTime];
    Float64 durationSeconds = [self playerItemDurationSeconds];
    Float64 progressTime = floorf(durationSeconds * progress);
    CMTime seekTime = CMTimeMakeWithSeconds(progressTime, time.timescale);
    //    [self.player seekToTime:seekTime];
    //    [self updateProgressView];
    
    if (CMTIME_IS_VALID(seekTime)) {
        __weak __typeof(self) weakSelf = self;
        [self.player seekToTime:seekTime
                toleranceBefore:CMTimeMake(1, 30)
                 toleranceAfter:CMTimeMake(1, 30)
              completionHandler:^(BOOL finished) {
                  [weakSelf updateProgressView];
              }];
    }
}

- (void)loadToProgress:(float)progress {
    CMTime time = [self playerItemDurationTime];
    Float64 durationSeconds = [self playerItemDurationSeconds];
    Float64 progressTime = floorf(durationSeconds * progress);
    CMTime seekTime = CMTimeMakeWithSeconds(progressTime, time.timescale);

    if (CMTIME_IS_VALID(seekTime)) {
        DEBUG_LOG(@"VP加载到指定的播放进度:%f 有效",progress);
        __weak __typeof(self) weakSelf = self;
        [self.player seekToTime:seekTime
              completionHandler:^(BOOL finished) {
                  [weakSelf updateProgressView];
                  if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoPlayerLoadToProgressCompletion:)]) {
                      [weakSelf.delegate videoPlayerLoadToProgressCompletion:weakSelf];
                  }
              }];
    }else{
        DEBUG_LOG(@"VP加载到指定的播放进度:%f 无效",progress);
        [self updateProgressView];
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerLoadToProgressCompletion:)]) {
            [self.delegate videoPlayerLoadToProgressCompletion:self];
        }
    }
}
#pragma mark -video loading

- (void)showVideoLoading {
    [self.playerControlView showVideoLoading];
}

- (void)hidenVideoLoading {
    [self.playerControlView hidenVideoLoading];
}

#pragma mark - CPlayerControlViewDelegate
/**
 *  开始拖拽播放头
 *
 *  @param controlView controlView
 *  @param progress 拖拽播放头时的播放进度
 */
- (void)playerControlView:(CPlayerControlView *)controlView beginDragProgress:(float)progress {
    [self pauseVideo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:beginDragProgress:)]) {
        [self.delegate videoPlayer:self beginDragProgress:progress];
    }
}

/**
 *  播放头拖拽中
 *
 *  @param controlView controlView
 *  @param progress 拖拽播放头时的播放进度
 */
- (void)playerControlView:(CPlayerControlView *)controlView moveDragProgress:(float)progress {
    [self seekToProgress:progress];

    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:moveDragProgress:)]) {
        [self.delegate videoPlayer:self moveDragProgress:progress];
    }
}

/**
 *  停止拖拽播放头
 *
 *  @param controlView controlView
 *  @param progress 拖拽播放头时的播放进度
 */
- (void)playerControlView:(CPlayerControlView *)controlView endDragProgress:(float)progress {
    [self seekToProgress:progress];
    if (!isPause) {
        [self play];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:endDragProgress:)]) {
        [self.delegate videoPlayer:self endDragProgress:progress];
    }
}

/**
 *  调整播放速度
 *
 *  @param controlView controlView
 *  @param rate  速度
 */
- (void)playerControlView:(CPlayerControlView *)controlView rateChange:(float)rate {

    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:rateChange:)]) {
        [self.delegate videoPlayer:self rateChange:rate];
    }

    self.rate = rate;
    self.player.rate = self.rate;

    if (isPause) {
        [self pause];
    }
}

/**
 *  调整视频音量
 *
 *  @param controlView controlView
 *  @param volume 调整后的音量值
 */
- (void)playerControlView:(CPlayerControlView *)controlView volumeChange:(float)volume {
}

/**
 *  播放按钮被点击
 *
 *  @param controlView controlView
 */
- (void)playerControlViewPlayButtonTouch:(CPlayerControlView *)controlView {
    BOOL currentPlayState=self.currentPlayState;
    DEBUG_LOG(@"播放按钮按下rate:%f",self.player.rate);
    if (currentPlayState) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)playerControlViewBeginPan:(CPlayerControlView *)controlView {

    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerBeginPan:)]) {
        [self.delegate videoPlayerBeginPan:self];
    }

    beginTime = self.player.currentTime;
    [self pauseVideo];
    [self.playerControlView showTimeTip];
}

- (void)playerControlView:(CPlayerControlView *)controlView panDirection:(CPlayerControlPanDirection)direction offsetX:(CGFloat)offsetX {
    //    [self.playerControlView showTimeTip];

    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:panDirection:offsetX:)]) {
        [self.delegate videoPlayer:self panDirection:direction offsetX:offsetX];
    }

    CMTime time = self.player.currentTime;

    CMTime offsetTime = CMTimeMake(30, 30);

    CMTime newTime;
    if (direction > 0) {
        newTime = CMTimeAdd(time, offsetTime);
        if (CMTimeGetSeconds(newTime) > [self playerItemDurationSeconds]) {
            newTime = [self playerItemDurationTime];
        }
    } else {
        newTime = CMTimeSubtract(time, offsetTime);
        if (newTime.value < 0) {
            newTime.value = 0;
        }
    }

    [self.playerControlView setTimeTipCurrentTime:CMTimeGetSeconds(newTime) duration:[self playerItemDurationSeconds] panDirection:direction];
    __weak __typeof(self) weakSelf = self;
    
    if (CMTIME_IS_VALID(newTime)) {
        [self.player seekToTime:newTime
                toleranceBefore:CMTimeMake(1, 30)
                 toleranceAfter:CMTimeMake(1, 30)
              completionHandler:^(BOOL finished) {
                  [weakSelf updateProgressView];
              }];
    }
    
    
}

- (void)playerControlViewEndPan:(CPlayerControlView *)controlView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerEndPan:)]) {
        [self.delegate videoPlayerEndPan:self];
    }

    [self.playerControlView hidenTimeTip];
    if (!isPause) {
        [self play];
    }
}

- (void)playerControlViewBackButtonOnTouch:(CPlayerControlView *)controlView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerOnBack:)]) {
        [self.delegate videoPlayerOnBack:self];
    }
}

- (void)dealloc {
    [self pauseVideo];
    [self.playerControlView destroy];
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:PlayerItem_Status_Key];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
