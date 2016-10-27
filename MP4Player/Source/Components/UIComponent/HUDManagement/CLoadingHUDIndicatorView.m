//
//
//  Created by Chentao on 16/9/13.
//  Copyright © 2016年 com.KaoChong. All rights reserved.
//

#import "CLoadingHUDIndicatorView.h"


@interface CLoadingHUDIndicatorView ()

@property (nonatomic, strong) CALayer *loadingLayer;

@end

@implementation CLoadingHUDIndicatorView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loadingLayer = [[CALayer alloc] init];
        
        self.loadingLayer.contents =(id)ImageMake(@"loading").CGImage;
        [self.layer addSublayer:self.loadingLayer];
        
        //旋转动画
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.removedOnCompletion = NO;
        
        rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 2];
        rotationAnimation.repeatCount = HUGE_VALF;
        
        rotationAnimation.duration = 2.0f;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0:0:1:1];
        [self.loadingLayer addAnimation:rotationAnimation forKey:@"transform.rotation.z"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    
    CGFloat loadingLayerW = 35;
    CGFloat loadingLayerH = 35;
    CGFloat loadingLayerX = 0.5 * (viewWidth - loadingLayerW);
    CGFloat loadingLayerY = 0.5 * (viewHeight - loadingLayerH);
    self.loadingLayer.frame = CGRectMake(loadingLayerX, loadingLayerY, loadingLayerW, loadingLayerH);
}

@end
