//
//  UIView+LayoutElement.h
//  UIComponents
//
//  Created by 陈涛 on 14-9-7.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutElement)

@property (strong, nonatomic) NSNumber *layout_left;
@property (strong, nonatomic) NSNumber *layout_right;
@property (strong, nonatomic) NSNumber *layout_top;
@property (strong, nonatomic) NSNumber *layout_bottom;
@property (strong, nonatomic) NSNumber *layout_verticalCenter;
@property (strong, nonatomic) NSNumber *layout_horizontalCenter;
@property (strong, nonatomic) NSNumber *layout_percentWidth;
@property (strong, nonatomic) NSNumber *layout_percentHeight;

@property (nonatomic, assign) BOOL includeInLayout;

@property (nonatomic, assign) CGFloat layout_x;
@property (nonatomic, assign) CGFloat layout_y;
@property (nonatomic, assign) CGFloat layout_width;
@property (nonatomic, assign) CGFloat layout_height;

- (void)removeAllSubviews;

@end
