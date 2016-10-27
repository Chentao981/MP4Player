//
//
//  Created by Chentao on 16/9/14.
//  Copyright © 2016年 com.KaoChong. All rights reserved.
//

#import "CSuccessHUDIndicatorView.h"

@interface CSuccessHUDIndicatorView()

@property (nonatomic, strong) CALayer *iconLayer;

@end


@implementation CSuccessHUDIndicatorView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.iconLayer = [[CALayer alloc] init];
        
        self.iconLayer.contents =(id)ImageMake(@"success").CGImage;
        [self.layer addSublayer:self.iconLayer];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    
    CGFloat promptLayerW = 30;
    CGFloat promptLayerH = 30;
    CGFloat promptLayerX = 0.5 * (viewWidth - promptLayerW);
    CGFloat promptLayerY = 0.5 * (viewHeight - promptLayerH);
    self.iconLayer.frame = CGRectMake(promptLayerX, promptLayerY, promptLayerW, promptLayerH);
}

@end
