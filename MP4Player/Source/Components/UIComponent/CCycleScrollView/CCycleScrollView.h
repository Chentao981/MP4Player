//
//  CCycleScrollView.h
//  ScrollViewUsing
//
//  Created by Chentao on 15/12/20.
//  Copyright © 2015年 Chentao. All rights reserved.
//

#import "NSObject+CEventDispatcher.h"
#import <UIKit/UIKit.h>

#pragma mark -Event
extern NSString *const CCycleScrollView_PageIndex_Change;
extern NSString *const CCycleScrollView_Touch;

@class CCycleScrollView;
@protocol CCycleScrollViewDelegate <NSObject>
@required

/**
 *总页数
 **/
- (NSInteger)cycleScrollViewTotalPageCount;

/**
 *cycleScrollView pageIndex页要展示的View
 **/
- (UIView *)cycleScrollView:(CCycleScrollView *)cycleScrollView pageIndex:(NSInteger)pageIndex;
@end

@interface CCycleScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, weak) id<CCycleScrollViewDelegate> delegate;

/**
 *重新加载数据
 **/
- (void)reloadData;

- (void)setPageIndex:(NSInteger)pageIndex animated:(BOOL)animated;

@end
