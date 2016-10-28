//
//  CPlayerControlView.h
//  CVideoPlayer
//
//  Created by Chentao on 16/7/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

typedef NS_ENUM(NSInteger, CPlayerControlPanDirection) {
    CPlayerControlPanDirectionRight = 1,
    CPlayerControlPanDirectionLeft = -1,
};

@class CPlayerControlView;

@protocol CPlayerControlViewDelegate <NSObject>

#pragma mark -拖拽画面相关
/**
 *  开始拖拽画面
 *
 *  @param controlView controlView
 */
- (void)playerControlViewBeginPan:(CPlayerControlView *)controlView;

/**
 *  拖拽画面中
 *
 *  @param controlView controlView
 *  @param direction 拖拽方向
 */
- (void)playerControlView:(CPlayerControlView *)controlView panDirection:(CPlayerControlPanDirection)direction offsetX:(CGFloat)offsetX;

/**
 *  停止拖拽画面
 *
 *  @param controlView controlView
 */
- (void)playerControlViewEndPan:(CPlayerControlView *)controlView;

#pragma mark -
#pragma mark -拖拽进度条相关
/**
 *  开始拖拽播放头
 *
 *  @param controlView controlView
 *  @param progress 拖拽播放头时的播放进度
 */
- (void)playerControlView:(CPlayerControlView *)controlView beginDragProgress:(float)progress;

/**
 *  播放头拖拽中
 *
 *  @param controlView controlView
 *  @param progress 拖拽播放头时的播放进度
 */
- (void)playerControlView:(CPlayerControlView *)controlView moveDragProgress:(float)progress;

/**
 *  停止拖拽播放头
 *
 *  @param controlView controlView
 *  @param progress 拖拽播放头时的播放进度
 */
- (void)playerControlView:(CPlayerControlView *)controlView endDragProgress:(float)progress;

#pragma mark -

/**
 *  调整播放速度
 *
 *  @param controlView controlView
 *  @param rate  调整的增量
 */
- (void)playerControlView:(CPlayerControlView *)controlView rateChange:(float)rate;

/**
 *  调整视频音量
 *
 *  @param controlView controlView
 *  @param volume 调整后的音量值
 */
- (void)playerControlView:(CPlayerControlView *)controlView volumeChange:(float)volume;

/**
 *  返回按钮被点击
 *
 *  @param controlView controlView
 */
- (void)playerControlViewBackButtonOnTouch:(CPlayerControlView *)controlView;

/**
 *  播放按钮被点击
 *
 *  @param controlView controlView
 */
- (void)playerControlViewPlayButtonTouch:(CPlayerControlView *)controlView;

@end

@interface CPlayerControlView : Group

@property (nonatomic, copy) NSString *title;

@property (nonatomic, weak) id<CPlayerControlViewDelegate> delegate;

/**
 *  用于显示的播放进度 0-1之间
 */
@property (nonatomic, assign) float progress;

/**
 *  用于显示的播放速度
 */
@property (nonatomic, assign) float rate;

/**
 *  用于显示的音量值
 */
@property (nonatomic, assign) float volume;

/**
 *  调用此方法播放按钮显示为暂停状态
 */
- (void)play;

/**
 *  调用此方法播放按钮显示为播放状态
 */
- (void)pause;

#pragma mark -Time Tips
/**
 *  显示时间tips
 */
- (void)showTimeTip;

/**
 *  隐藏时间tips
 */
- (void)hidenTimeTip;

#pragma mark -video loading

- (void)showVideoLoading;

- (void)hidenVideoLoading;

#pragma mark -

- (void)setTimeTipCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration panDirection:(CPlayerControlPanDirection)direction;

- (void)setTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;

- (void)destroy;

#pragma mark -

@end
