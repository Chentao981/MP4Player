//
//  VBox.m
//  UIComponents
//
//  Created by 陈涛 on 14-9-7.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "VBox.h"

@implementation VBox

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    if (self.measureSizes) {
        CGSize measureSize = [self measureSize];

        BOOL resize = NO;
        if (measureSize.width != self.bounds.size.width || measureSize.height != self.bounds.size.height) {
            resize = YES;
        }

        CGRect newFrame = self.frame;
        newFrame.size.width = measureSize.width;
        newFrame.size.height = measureSize.height;
        self.frame = newFrame;
        [self layoutChildWithSize:measureSize];

        if (resize) {
            if (self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(reSizeWithBox:)]) {
                [self.boxDelegate reSizeWithBox:self];
            }

            if (self.superview) {
                [self.superview setNeedsLayout];
            }
        }
    } else {
        [self layoutChildWithSize:self.bounds.size];
    }
}

- (CGSize)measureBoxSize {
    return [self measureSize];
}

/**
 * 测量大小
 **/
- (CGSize)measureSize {
    CGSize size = CGSizeMake(0.0, 0.0);

    int i = 0;
    NSUInteger numChild = self.subviews.count;

    CGFloat maxW = 0.0;

    CGFloat measureW = self.paddingLeft;
    CGFloat measureH = self.paddingTop;

    for (i = 0; i < numChild; i++) {
        UIView *child = [self.subviews objectAtIndex:i];
        if (maxW < child.frame.size.width) {
            maxW = child.frame.size.width;
        }
        if (child.includeInLayout) {
            measureH += child.frame.size.height;
            if (i < (numChild - 1)) {
                measureH += self.gap;
            }
        }
    }

    measureH += self.paddingBottom;
    measureW += maxW + self.paddingRight;

    size.width = measureW;
    size.height = measureH;
    return size;
}

- (void)layoutChildWithSize:(CGSize)size {
    int i = 0;
    NSUInteger numChild = self.subviews.count;

    CGFloat childY = self.paddingTop;
    for (i = 0; i < numChild; i++) {
        UIView *child = [self.subviews objectAtIndex:i];
        if (child.includeInLayout) {
            CGFloat childX = 0.0;
            if (BoxAlignTypeLeft == self.horizontalAlign) {
                childX = self.paddingLeft;
            } else if (BoxAlignTypeCenter == self.horizontalAlign) {
                childX = 0.5 * (size.width - child.frame.size.width);
            } else if (BoxAlignTypeRight == self.horizontalAlign) {
                childX = size.width - self.paddingRight - child.frame.size.width;
            }
            child.frame = CGRectMake(childX, childY, child.frame.size.width, child.frame.size.height);
            childY += child.frame.size.height + self.gap;
        }
    }
}

@end
