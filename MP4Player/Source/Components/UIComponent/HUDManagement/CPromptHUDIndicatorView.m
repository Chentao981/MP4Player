//
//
//  Created by Chentao on 16/9/13.
//  Copyright © 2016年 com.KaoChong. All rights reserved.
//

#import "CPromptHUDIndicatorView.h"


@interface CPromptHUDIndicatorView()

@property (nonatomic, strong) CALayer *promptLayer;

@end

@implementation CPromptHUDIndicatorView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.promptLayer = [[CALayer alloc] init];
        
        self.promptLayer.contents =(id)ImageMake(@"prompt").CGImage;
        [self.layer addSublayer:self.promptLayer];
        
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
    self.promptLayer.frame = CGRectMake(promptLayerX, promptLayerY, promptLayerW, promptLayerH);
}

@end
