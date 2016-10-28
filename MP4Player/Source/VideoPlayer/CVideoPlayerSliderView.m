//
//  CVideoPlayerSliderView.m
//  CVideoPlayer
//
//  Created by Chentao on 16/7/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CVideoPlayerSliderView.h"

@interface CVideoPlayerSliderView ()

@property (nonatomic, strong) UIButton *controlButton;

@property (nonatomic, strong) UIView *progressBGView;

@property (nonatomic, strong) UIView *progressView;

@end

@implementation CVideoPlayerSliderView {
    CGPoint beganPoint;
    
    CGSize controlButtonSize;
    CGSize controlButtonVisualSize;
}

@synthesize sliderValue = _sliderValue;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor purpleColor];
        
        controlButtonSize = CGSizeMake(50, 50);
        controlButtonVisualSize = CGSizeMake(20, 20);
        
        self.sliderValue = 0.0;
        self.progressHeight = 10;
        self.progressBGView = [[UIView alloc] init];
         self.progressBGView.backgroundColor =[ColorMake(0xFFFFFF) colorWithAlphaComponent:0.4];
        [self addSubview:self.progressBGView];
        
        self.progressView = [[UIView alloc] init];
        self.progressView.backgroundColor = ColorMake(0xFAC842);
//        self.progressView.backgroundColor = [UIColor colorWithRed:(float)0xFA / 0xFF green:(float)0xC8 / 0xFF blue:(float)0x42 / 0xFF alpha:1.0];
        [self addSubview:self.progressView];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizerHandler:)];
        
        self.controlButton = [[UIButton alloc] init];
        self.controlButton.frame = CGRectMake(0, 0, controlButtonSize.width, controlButtonSize.height);
//        self.controlButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
        self.controlButton.clipsToBounds = NO;
        [self.controlButton setImage:[UIImage imageNamed:@"videoplayer_slider"] forState:UIControlStateNormal];
        [self.controlButton addGestureRecognizer:panRecognizer];
        [self addSubview:self.controlButton];
    }
    
    return self;
}

- (void)panRecognizerHandler:(UIPanGestureRecognizer *)recognizer {
    UIView *panView = recognizer.view;
    CGPoint centerPoint = [recognizer locationInView:panView];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            beganPoint = centerPoint;
            _sliderValue = [self currentValue];
            [self setNeedsLayout];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:startDragValue:)]) {
                [self.delegate sliderView:self startDragValue:self.sliderValue];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGFloat offsetx = centerPoint.x - beganPoint.x;
            CGPoint viewCenterPoint = CGPointMake(panView.center.x + offsetx, panView.center.y);
            
            CGFloat viewWidth = CGRectGetWidth(self.bounds);
            
            if (viewCenterPoint.x < 0.5 * controlButtonVisualSize.width) {
                viewCenterPoint.x = 0.5 * controlButtonVisualSize.width;
            }
            
            if (viewCenterPoint.x > viewWidth - 0.5 * controlButtonVisualSize.width) {
                viewCenterPoint.x = viewWidth - 0.5 * controlButtonVisualSize.width;
            }
            
            
            
            
            recognizer.view.center = viewCenterPoint;
            //[recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
            
            _sliderValue = [self currentValue];
            
            [self setNeedsLayout];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:moveDragValue:)]) {
                [self.delegate sliderView:self moveDragValue:self.sliderValue];
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        default: {
            _sliderValue = [self currentValue];
            
            [self setNeedsLayout];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:endDragValue:)]) {
                [self.delegate sliderView:self endDragValue:self.sliderValue];
            }
            break;
        }
    }
}

- (void)setSliderValue:(float)sliderValue {
    _sliderValue = sliderValue;
    
    if (_sliderValue < 0) {
        _sliderValue = 0;
    }
    
    if (_sliderValue > 1) {
        _sliderValue = 1;
    }
    
    [self setNeedsLayout];
}

- (float)sliderValue {
    if (isnan(_sliderValue)) {
        return 0.0f;
    }
    return _sliderValue;
}

- (float)currentValue {
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat progress = (CGRectGetMidX(self.controlButton.frame) - 0.5 * controlButtonVisualSize.width) / (viewWidth - controlButtonVisualSize.width);
    return progress;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    
    CGFloat controlButtonCenterX = 0.5 * controlButtonVisualSize.width + self.sliderValue * (viewWidth - controlButtonVisualSize.width);
    CGFloat controlButtonCenterY = 0.5 * viewHeight;
    self.controlButton.center = CGPointMake(controlButtonCenterX, controlButtonCenterY);
    
    CGFloat progressBGViewW = viewWidth;
    CGFloat progressBGViewH = self.progressHeight;
    CGFloat progressBGViewX = 0;
    CGFloat progressBGViewY = 0.5 * (viewHeight - progressBGViewH);
    self.progressBGView.frame = CGRectMake(progressBGViewX, progressBGViewY, progressBGViewW, progressBGViewH);
    
    CGFloat progressViewW = CGRectGetMidX(self.controlButton.frame);
    CGFloat progressViewH = self.progressHeight;
    CGFloat progressViewX = 0;
    CGFloat progressViewY = 0.5 * (viewHeight - progressViewH);
    self.progressView.frame = CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH);
}

@end
