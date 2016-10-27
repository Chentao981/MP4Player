//
//  Box.h
//  UIComponents
//
//  Created by 陈涛 on 14-9-7.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+LayoutElement.h"

typedef NS_ENUM(NSInteger, BoxAlignType) {
    BoxAlignTypeTop = 0,
    BoxAlignTypeBottom,
    BoxAlignTypeLeft,
    BoxAlignTypeRight,
    BoxAlignTypeCenter,
};

@class Box;
@protocol BoxDelegate <NSObject>
- (void)reSizeWithBox:(Box *)box;
@end

@interface Box : UIView

@property (nonatomic) BOOL measureSizes;

@property (nonatomic) CGFloat gap;

@property (nonatomic) CGFloat paddingTop;
@property (nonatomic) CGFloat paddingBottom;
@property (nonatomic) CGFloat paddingLeft;
@property (nonatomic) CGFloat paddingRight;

@property (nonatomic) BoxAlignType verticalAlign;
@property (nonatomic) BoxAlignType horizontalAlign;

@property (nonatomic, weak) id<BoxDelegate> boxDelegate;

- (CGSize)measureBoxSize;

@end
