//
//  UIView+LayoutElement.m
//  UIComponents
//
//  Created by 陈涛 on 14-9-7.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "UIView+LayoutElement.h"
#import <objc/runtime.h>

static const char LEFT;
static const char RIGHT;
static const char TOP;
static const char BOTTOM;

static const char VERTICAL_CENTER;
static const char HORIZONTAL_CENTER;
static const char PERCENT_WIDTH;
static const char PERCENT_HEIGHT;

static const char INCLUDE_IN_LAYOUT;

@implementation UIView (LayoutElement)

@dynamic layout_left;
@dynamic layout_right;
@dynamic layout_top;
@dynamic layout_bottom;
@dynamic layout_verticalCenter;
@dynamic layout_horizontalCenter;
@dynamic layout_percentWidth;
@dynamic layout_percentHeight;

@dynamic includeInLayout;

- (void)setLayout_x:(CGFloat)layout_x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = layout_x;
    self.frame = newFrame;
}

- (CGFloat)layout_x {
    return self.frame.origin.x;
}

- (void)setLayout_y:(CGFloat)layout_y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = layout_y;
    self.frame = newFrame;
}

- (CGFloat)layout_y {
    return self.frame.origin.y;
}

- (void)setLayout_width:(CGFloat)layout_width {
    CGRect newFrame = self.frame;
    newFrame.size.width = layout_width;
    self.frame = newFrame;
}

- (CGFloat)layout_width {
    return self.frame.size.width;
}

- (void)setLayout_height:(CGFloat)layout_height {
    CGRect newFrame = self.frame;
    newFrame.size.height = layout_height;
    self.frame = newFrame;
}

- (CGFloat)layout_height {
    return self.frame.size.height;
}

/**
 * left
 **/
- (void)setLayout_left:(NSNumber *)layout_left {
    [self setLayoutWithPropertyName:(void *)&LEFT andValue:layout_left];
}

- (NSNumber *)layout_left {
    return objc_getAssociatedObject(self, &LEFT);
}

/**
 * right
 **/
- (void)setLayout_right:(NSNumber *)layout_right {
    [self setLayoutWithPropertyName:(void *)&RIGHT andValue:layout_right];
}

- (NSNumber *)layout_right {
    return objc_getAssociatedObject(self, &RIGHT);
}

/**
 * top
 **/
- (void)setLayout_top:(NSNumber *)layout_top {
    [self setLayoutWithPropertyName:(void *)&TOP andValue:layout_top];
}

- (NSNumber *)layout_top {
    return objc_getAssociatedObject(self, &TOP);
}

/**
 * bottom
 **/
- (void)setLayout_bottom:(NSNumber *)layout_bottom {
    [self setLayoutWithPropertyName:(void *)&BOTTOM andValue:layout_bottom];
}

- (NSNumber *)layout_bottom {
    return objc_getAssociatedObject(self, &BOTTOM);
}

/**
 * verticalCenter
 **/
- (void)setLayout_verticalCenter:(NSNumber *)layout_verticalCenter {
    [self setLayoutWithPropertyName:(void *)&VERTICAL_CENTER andValue:layout_verticalCenter];
}

- (NSNumber *)layout_verticalCenter {
    return objc_getAssociatedObject(self, &VERTICAL_CENTER);
}

/**
 * horizontalCenter
 **/
- (void)setLayout_horizontalCenter:(NSNumber *)layout_horizontalCenter {
    [self setLayoutWithPropertyName:(void *)&HORIZONTAL_CENTER andValue:layout_horizontalCenter];
}

- (NSNumber *)layout_horizontalCenter {
    return objc_getAssociatedObject(self, &HORIZONTAL_CENTER);
}

/**
 * percentHeight
 **/
- (void)setLayout_percentHeight:(NSNumber *)layout_percentHeight {
    [self setLayoutWithPropertyName:(void *)&PERCENT_HEIGHT andValue:layout_percentHeight];
}

- (NSNumber *)layout_percentHeight {
    return objc_getAssociatedObject(self, &PERCENT_HEIGHT);
}

/**
 * percentWidth
 **/
- (void)setLayout_percentWidth:(NSNumber *)layout_percentWidth {
    [self setLayoutWithPropertyName:(void *)&PERCENT_WIDTH andValue:layout_percentWidth];
}

- (NSNumber *)layout_percentWidth {
    return objc_getAssociatedObject(self, &PERCENT_WIDTH);
}

/**
 * includeInLayout
 **/
- (void)setIncludeInLayout:(BOOL)includeInLayout {
    NSNumber *oldValue = objc_getAssociatedObject(self, &INCLUDE_IN_LAYOUT);
    if ([oldValue charValue] ^ includeInLayout) {
        objc_setAssociatedObject(self, (void *)&INCLUDE_IN_LAYOUT, [NSNumber numberWithChar:includeInLayout], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setSuperviewNeedsLayout];
    }
}

- (BOOL)includeInLayout {
    NSNumber *value = objc_getAssociatedObject(self, &INCLUDE_IN_LAYOUT);
    return [value charValue];
}

- (void)setLayoutWithPropertyName:(void *)key andValue:(NSNumber *)newValue {
    NSNumber *oldValue = objc_getAssociatedObject(self, key);

    CGFloat oldValueFloatValue = [oldValue floatValue];
    CGFloat newValueFloatValue = [newValue floatValue];

    if (oldValue != newValue) {
        if (nil == newValue || nil == oldValue) {
            objc_setAssociatedObject(self, key, newValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setSuperviewNeedsLayout];
        } else {
            if (oldValueFloatValue != newValueFloatValue) {
                objc_setAssociatedObject(self, key, newValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setSuperviewNeedsLayout];
            }
        }
    } else {
        if (oldValueFloatValue != newValueFloatValue) {
            objc_setAssociatedObject(self, key, newValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setSuperviewNeedsLayout];
        }
    }
}

- (void)setSuperviewNeedsLayout {
    if (self.superview) {
        [self.superview setNeedsLayout];
    }
}

- (void)removeAllSubviews {
    NSInteger subviewCount = self.subviews.count;
    for (NSInteger index = (subviewCount - 1); index >= 0; index--) {
        UIView *subview = [self.subviews objectAtIndex:index];
        [subview removeFromSuperview];
    }
}

@end
