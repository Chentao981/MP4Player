//
//  IMCheckBox.h
//  IMRadioButtonUseing
//
//  Created by Chentao on 14/10/22.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMCheckBox;
@protocol IMCheckBoxDelegate <NSObject>
/**
 * 当checkBox被点击时触发
 **/
@optional
- (void)checkBoxOnTouch:(IMCheckBox *)checkBox;

/**
 * 当selected状态发生变化时触发
 **/
- (void)checkBoxOnSelectedChange:(IMCheckBox *)checkBox;
@end

@class IMCheckBox;

@interface IMCheckBox : UIView

@property (nonatomic, weak) id<IMCheckBoxDelegate> delegate;

@property (nonatomic, assign) BOOL selected;

/**
 * 指定在文字被更改时是否自动计算大小。
 **/
@property (nonatomic, assign) BOOL measureSize;

/**
 * label文字,在设置完文字后，组件会自动计算自己的宽高。
 **/
@property (nonatomic, copy) NSString *labelText;

/**
 * label字体
 **/
@property (nonatomic, strong) UIFont *labelFont;

/**
 * label颜色
 **/
@property (nonatomic, strong) UIColor *labelColor;

/**
 * label选中颜色
 **/
@property (nonatomic, strong) UIColor *selectedLabelColor;

/**
 * label与icon的间隙
 **/
@property (nonatomic, assign) CGFloat gap;

/**
 * 未选中状态时的icon，默认情况下不需要设置，组件初始化时会自动创建默认图标
 **/
@property (nonatomic, strong) UIImage *normIcon;

/**
 * 选中状态时的icon，默认情况下不需要设置，组件初始化时会自动创建默认图标
 **/
@property (nonatomic, strong) UIImage *selectedIcon;

/**
 *组件携带的数据
 **/
@property (nonatomic, strong) id userData;

/**
 *选中时是否显示动效
 **/
@property (nonatomic, assign) BOOL selectedShowAnimation;

- (void)touchHandler;
@end
