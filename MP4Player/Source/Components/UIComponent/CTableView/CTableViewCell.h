//
//  CTableViewCell.h
//  CoolLibrary
//
//  Created by Chentao on 16/6/19.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) CGFloat topLineLeftPadding;
@property (nonatomic, assign) CGFloat topLineRightPadding;
@property (nonatomic, strong) UIColor *topLineColor;

@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, assign) CGFloat bottomLineLeftPadding;
@property (nonatomic, assign) CGFloat bottomLineRightPadding;
@property (nonatomic, strong) UIColor *bottomLineColor;

@property (nonatomic, strong) id data;

#pragma mark -子类覆盖，无需手动调用

- (void)createSubviews;

- (void)setCellLineProperty;

- (void)updateDisplayListViewWidth:(CGFloat)viewWidth viewHeight:(CGFloat)viewHeight;

#pragma mark -

@end
