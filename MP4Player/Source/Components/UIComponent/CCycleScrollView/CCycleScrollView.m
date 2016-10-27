//
//  CCycleScrollView.m
//  ScrollViewUsing
//
//  Created by Chentao on 15/12/20.
//  Copyright © 2015年 Chentao. All rights reserved.
//

#import "CCycleScrollView.h"

#define CCycleScrollView_PageCount 3

NSString *const CCycleScrollView_PageIndex_Change = @"CCycleScrollView_PageIndex_Change";
NSString *const CCycleScrollView_Touch = @"CCycleScrollView_Touch";

@interface CCycleScrollView ()
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, assign) NSInteger currentPageIndex;
@end

@implementation CCycleScrollView {
    UIScrollView *scrollView;
    NSMutableArray *contentViews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentPageIndex = 0;

        scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.contentMode = UIViewContentModeCenter;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler)];
        [scrollView addGestureRecognizer:tapGesture];

        [self addSubview:scrollView];
    }
    return self;
}

- (void)tapGestureHandler {
    CEvent *event = [[CEvent alloc] initWithType:CCycleScrollView_Touch andData:[NSNumber numberWithInteger:_currentPageIndex]];
    [self dispatchEvent:event];
}

- (void)reloadData {
    [self configContentViews];
}

#pragma mark -

- (NSInteger)totalPageCount {
    NSInteger totalPageCount = 0;
    if (self.delegate) {
        totalPageCount = [self.delegate cycleScrollViewTotalPageCount];
    }
    if (totalPageCount < 2) {
        scrollView.scrollEnabled = NO;
    } else {
        scrollView.scrollEnabled = YES;
    }
    return totalPageCount;
}

- (void)setPageIndex:(NSInteger)pageIndex animated:(BOOL)animated {
    // NSLog(@"OffsetX:%f width:%f", scrollView.contentOffset.x, CGRectGetWidth(scrollView.frame));
    CGFloat contentOffsetX = CGRectGetWidth(scrollView.frame);

    if (_currentPageIndex == pageIndex) {
        return;
    }
    if (_currentPageIndex > pageIndex) {
        self.currentPageIndex = pageIndex + 1;
        CGPoint newOffset = CGPointMake(contentOffsetX - CGRectGetWidth(scrollView.frame), scrollView.contentOffset.y);
        [scrollView setContentOffset:newOffset animated:YES];
    } else {
        self.currentPageIndex = pageIndex - 1;
        CGPoint newOffset = CGPointMake(contentOffsetX + CGRectGetWidth(scrollView.frame), scrollView.contentOffset.y);
        [scrollView setContentOffset:newOffset animated:YES];
    }
}

- (void)setPageIndex:(NSInteger)pageIndex {
    self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:pageIndex];
    [self configContentViews];
}

- (NSInteger)pageIndex {
    return _currentPageIndex;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    if (_currentPageIndex != currentPageIndex) {
        _currentPageIndex = currentPageIndex;

        CEvent *event = [[CEvent alloc] initWithType:CCycleScrollView_PageIndex_Change andData:[NSNumber numberWithInteger:_currentPageIndex]];
        [self dispatchEvent:event];
    }
}

#pragma mark -
/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource {
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];

    // NSLog(@"%ld  %ld  %ld", previousPageIndex, _currentPageIndex, rearPageIndex);

    if (self.delegate) {
        [contentViews addObject:[self.delegate cycleScrollView:self pageIndex:previousPageIndex]];
        [contentViews addObject:[self.delegate cycleScrollView:self pageIndex:_currentPageIndex]];
        [contentViews addObject:[self.delegate cycleScrollView:self pageIndex:rearPageIndex]];
    }
}

- (void)configContentViews {
    [contentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!contentViews) {
        contentViews = [[NSMutableArray alloc] init];
    }
    [contentViews removeAllObjects];

    if (self.delegate && [self totalPageCount] > 0) {
        [self setScrollViewContentDataSource];
        NSInteger subCount = contentViews.count;
        CGFloat scrollViewWidth = CGRectGetWidth(scrollView.frame);
        CGFloat scrollViewHeight = CGRectGetHeight(scrollView.frame);
        for (NSInteger index = 0; index < subCount; index++) {
            UIView *contentView = [contentViews objectAtIndex:index];
            contentView.userInteractionEnabled = NO;
            CGRect contentViewFrame = contentView.frame;
            contentViewFrame.origin.x = index * scrollViewWidth;
            contentViewFrame.origin.y = 0;
            contentViewFrame.size.width = scrollViewWidth;
            contentViewFrame.size.height = scrollViewHeight;
            contentView.frame = contentViewFrame;
            [scrollView addSubview:contentView];
        }
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)index {
    if (0 == [self totalPageCount]) {
        return 0;
    }

    if (index == -1) {
        return [self totalPageCount] - 1;
    } else if (index == [self totalPageCount]) {
        return 0;
    } else {
        return index;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

- (void)scrollViewDidScroll:(UIScrollView *)view {
    if (self.delegate) {
        int contentOffsetX = view.contentOffset.x;
        if (contentOffsetX >= (2 * CGRectGetWidth(view.frame))) {
            self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
            [self configContentViews];
        }
        if (contentOffsetX <= 0) {
            self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
            [self configContentViews];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)view {
    if (self.delegate && [self totalPageCount] > 0) {
        [view setContentOffset:CGPointMake(CGRectGetWidth(view.frame), 0) animated:YES];
    }
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);

    scrollView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    scrollView.contentSize = CGSizeMake(CCycleScrollView_PageCount * viewWidth, viewHeight);

    NSInteger count = contentViews.count;
    for (NSInteger index = 0; index < count; index++) {
        UIView *subView = [contentViews objectAtIndex:index];
        subView.frame = CGRectMake(index * viewWidth, 0, viewWidth, viewHeight);
    }
    [scrollView setContentOffset:CGPointMake(viewWidth, 0)];
}

@end
