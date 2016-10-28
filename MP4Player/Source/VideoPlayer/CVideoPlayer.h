//
//  CPlayerView.h
//  CVideoPlayer
//
//  Created by Chentao on 16/7/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@class CVideoPlayer;

@protocol CVideoPlayerDelegate <NSObject>

@optional
/**
 *  播放器资源将要开始加载资源
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayerWillLoadAsset:(CVideoPlayer *)videoPlayer;

/**
 *  播放器资源已准备好
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayerAssetOnReady:(CVideoPlayer *)videoPlayer;

/**
 *  播放器播放资源完成
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayerDidPlayToEndTime:(CVideoPlayer *)videoPlayer;

/**
 *  播放器加载资源失败
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayer:(CVideoPlayer *)videoPlayer loadAssetFailed:(NSError *)error;

/**
 *  播放进度发生变化
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayer:(CVideoPlayer *)videoPlayer changeCurrentTime:(Float64)currentTime duration:(Float64)duration;

/**
 *  播放器加载资源失败
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayerOnBack:(CVideoPlayer *)videoPlayer;

/**
 *  加载到指定进度时可能会需要一些时间，在完成时调用此回调
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayerLoadToProgressCompletion:(CVideoPlayer *)videoPlayer;

/**
 *  将要调用play方法
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayerWillCallPlay:(CVideoPlayer *)videoPlayer;

/**
 *  将要play方法完成
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayerDidCallPlay:(CVideoPlayer *)videoPlayer;



/**
 *  将要调用pause方法
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayerWillCallPause:(CVideoPlayer *)videoPlayer;

/**
 *  将要pause方法完成
 *
 *  @param videoPlayer videoPlayer
 */
- (void)videoPlayerDidCallPause:(CVideoPlayer *)videoPlayer;


#pragma mark -拖拽进度条相关

/**
 *  开始拖拽播放头
 *
 *  @param videoPlayer videoPlayer
 *  @param progress    拖拽播放头时的播放进度
 */
- (void)videoPlayer:(CVideoPlayer *)videoPlayer beginDragProgress:(float)progress;

/**
 *  播放头拖拽中
 *
 *  @param videoPlayer videoPlayer
 *  @param progress    拖拽播放头时的播放进度
 */
- (void)videoPlayer:(CVideoPlayer *)videoPlayer moveDragProgress:(float)progress;

/**
 *  停止拖拽播放头
 *
 *  @param videoPlayer videoPlayer
 *  @param progress    拖拽播放头时的播放进度
 */
- (void)videoPlayer:(CVideoPlayer *)videoPlayer endDragProgress:(float)progress;

#pragma mark -拖拽屏幕
- (void)videoPlayerBeginPan:(CVideoPlayer *)videoPlayer;

- (void)videoPlayer:(CVideoPlayer *)videoPlayer panDirection:(CPlayerControlPanDirection)direction offsetX:(CGFloat)offsetX;

- (void)videoPlayerEndPan:(CVideoPlayer *)videoPlayer;
#pragma mark -

- (void)videoPlayer:(CVideoPlayer *)videoPlayer rateChange:(float)rate;


@end

@interface CVideoPlayer : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, weak) id<CVideoPlayerDelegate> delegate;

/**
 *  播放器控制UI
 */
@property (nonatomic, readonly) CPlayerControlView *playerControlView;

- (void)loadVideoWithURL:(NSURL *)url;

#pragma mark -Play Control
/**
 *  播放进度 0-1之间
 */
@property (nonatomic, readonly) float progress;

///**
// *  音量
// */
//@property (nonatomic, assign) float volume;

///**
// *  是否自动播放
// */
//@property (nonatomic, assign) BOOL autoPlay;

/**
 *  是否在播放
 */
@property (nonatomic, readonly) BOOL isPlay;

/**
 *  当前视频文件的时长
 */
@property (nonatomic, assign, readonly) CMTime playerItemDurationTime;

/**
 *  当前视频的播放时间
 */
@property (nonatomic, assign, readonly) CMTime currentTime;

/**
 *  开始播放
 */
- (void)play;

/**
 *  暂停播放
 */
- (void)pause;

/**
 *  跳到指定的时间点
 *
 *  @param time time
 */
- (void)seekToTime:(NSTimeInterval)time;

/**
 *  跳到指定的进度 ，百分比
 *
 *  @param progress progress
 */
- (void)seekToProgress:(float)progress;

/**
 *  加载视频到指定的进度
 *
 *  @param progress progress
 */
- (void)loadToProgress:(float)progress;

#pragma mark -video loading

- (void)showVideoLoading;

- (void)hidenVideoLoading;

@end
