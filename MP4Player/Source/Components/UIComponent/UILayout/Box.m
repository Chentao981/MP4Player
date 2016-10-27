//
//  Box.m
//  UIComponents
//  抽象父类，请使用它的子类。
//  Created by 陈涛 on 14-9-7.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "Box.h"

@implementation Box

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _gap = 0.0;
        _paddingBottom = 0;
        _paddingLeft = 0;
        _paddingRight = 0;
        _paddingTop = 0;
        _verticalAlign = BoxAlignTypeTop;
        _horizontalAlign = BoxAlignTypeLeft;
        _measureSizes = false;
    }
    return self;
}

- (void)setMeasureSizes:(BOOL)measureSizes {
    if (_measureSizes ^ measureSizes) {
        _measureSizes = measureSizes;
        [self setNeedsLayout];
    }
}

- (void)setGap:(CGFloat)gap {
    if (_gap != gap) {
        _gap = gap;
        [self setNeedsLayout];
    }
}

- (void)setVerticalAlign:(BoxAlignType)verticalAlign {
    if (_verticalAlign != verticalAlign) {
        _verticalAlign = verticalAlign;
        [self setNeedsLayout];
    }
}

- (void)setHorizontalAlign:(BoxAlignType)horizontalAlign {
    if (_horizontalAlign != horizontalAlign) {
        _horizontalAlign = horizontalAlign;
        [self setNeedsLayout];
    }
}

- (void)setPaddingTop:(CGFloat)paddingTop {
    if (_paddingTop != paddingTop) {
        _paddingTop = paddingTop;
        [self setNeedsLayout];
    }
}

- (void)setPaddingBottom:(CGFloat)paddingBottom {
    if (_paddingBottom != paddingBottom) {
        _paddingBottom = paddingBottom;
        [self setNeedsLayout];
    }
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    if (_paddingLeft != paddingLeft) {
        _paddingLeft = paddingLeft;
        [self setNeedsLayout];
    }
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    if (_paddingRight != paddingRight) {
        _paddingRight = paddingRight;
        [self setNeedsLayout];
    }
}

- (CGSize)measureBoxSize {
    return CGSizeZero;
}

@end
