//
//  CVideoPlayerSliderView.h
//  CVideoPlayer
//
//  Created by Chentao on 16/7/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CVideoPlayerSliderView;

@protocol CVideoPlayerSliderViewDelegate <NSObject>

/**
 *  开始拖拽
 *
 *  @param sliderView sliderView
 *  @param value value
 */
-(void)sliderView:(CVideoPlayerSliderView *)sliderView startDragValue:(float)value;

/**
 *  拖拽中
 *
 *  @param sliderView sliderView
 *  @param value value
 */
-(void)sliderView:(CVideoPlayerSliderView *)sliderView moveDragValue:(float)value;

/**
 *  拖拽结束
 *
 *  @param sliderView sliderView
 *  @param value value
 */
-(void)sliderView:(CVideoPlayerSliderView *)sliderView endDragValue:(float)value;

@end



@interface CVideoPlayerSliderView : UIView

@property(nonatomic,assign)float sliderValue;

@property(nonatomic,assign)CGFloat progressHeight;

@property(nonatomic,weak)id <CVideoPlayerSliderViewDelegate> delegate;

@end
