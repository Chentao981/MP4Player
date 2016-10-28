//
//  CVideoPlayerSpeedMenuView.m
//  CVideoPlayer
//
//  Created by Chentao on 16/8/9.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CVideoPlayerSpeedMenuView.h"

@implementation CVideoPlayerSpeedMenuItem

- (void)setSelected:(BOOL)selected {
    if (_selected ^ selected) {
        _selected = selected;
        CEvent *event = [[CEvent alloc] initWithType:CVideoPlayerSpeedMenuItem_Selected_Change andData:self];
        [self dispatchEvent:event];
    }
}

@end

@implementation CVideoPlayerSpeedMenuItemView {
    UIView *bottomLineView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel.font = FontMake(12);
        self.backgroundColor = [ColorMake(0x000000) colorWithAlphaComponent:0.8];
        bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = [ColorMake(0xFFFFFF) colorWithAlphaComponent:0.2];
        [self addSubview:bottomLineView];
    }
    return self;
}

- (void)setMenuItem:(CVideoPlayerSpeedMenuItem *)menuItem {
    _menuItem = menuItem;

    NSString *titleText = [NSString stringWithFormat:@"X%.1f", _menuItem.speed];
    [self setTitle:titleText forState:UIControlStateNormal];

    [self setTitleColor:ColorMake(0xFFFFFF) forState:UIControlStateNormal];
    [self setTitleColor:ColorMake(0xFAC842) forState:UIControlStateSelected];

    [_menuItem addEventListenerWithType:CVideoPlayerSpeedMenuItem_Selected_Change target:self action:@selector(itemSelectedChangeHandler:)];
    [self setNeedsLayout];
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    bottomLineView.hidden = !showBottomLine;
}

- (BOOL)showBottomLine {
    return !bottomLineView.hidden;
}

- (void)itemSelectedChangeHandler:(CEvent *)event {
    self.selected = _menuItem.selected;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);

    CGFloat bottomLineViewW = viewWidth;
    CGFloat bottomLineViewH = 0.5;
    CGFloat bottomLineViewX = 0;
    CGFloat bottomLineViewY = viewHeight - bottomLineViewH;
    bottomLineView.frame = CGRectMake(bottomLineViewX, bottomLineViewY, bottomLineViewW, bottomLineViewH);
}

@end

@interface CVideoPlayerSpeedMenuView ()
@property (nonatomic, strong) UIView *maskEffectView;
@end

@implementation CVideoPlayerSpeedMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.maskEffectView = [[UIView alloc] init];
        self.maskEffectView.backgroundColor = ColorMake(0x000000);
        self.maskView = self.maskEffectView;
        _show = NO;
    }
    return self;
}

- (void)setSpeedArray:(NSArray<CVideoPlayerSpeedMenuItem *> *)speedArray {
    _speedArray = speedArray;
    [self removeAllSubviews];

    NSInteger arrayCount = _speedArray.count;
    for (NSInteger index = 0; index < arrayCount; index++) {
        CVideoPlayerSpeedMenuItem *menuItem = [_speedArray objectAtIndex:index];
        CVideoPlayerSpeedMenuItemView *itemView = [[CVideoPlayerSpeedMenuItemView alloc] init];
        [itemView addTarget:self action:@selector(menuItemViewTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
        itemView.includeInLayout = YES;
        itemView.frame = CGRectMake(0, 0, 60, 40);
        itemView.menuItem = menuItem;

        if (index < (arrayCount - 1)) {
            itemView.showBottomLine = YES;
        } else {
            itemView.showBottomLine = NO;
        }

        [self addSubview:itemView];
    }
}

- (void)menuItemViewTouchHandler:(CVideoPlayerSpeedMenuItemView *)itemView {
    for (CVideoPlayerSpeedMenuItem *item in _speedArray) {
        if (itemView.menuItem == item) {
            item.selected = YES;
        } else {
            item.selected = NO;
        }
    }

    CEvent *event = [[CEvent alloc] initWithType:CVideoPlayerSpeedMenuView_DidSelected andData:itemView.menuItem];
    [self dispatchEvent:event];
}

- (void)showMenuView {
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    self.maskEffectView.frame = CGRectMake(0, viewHeight, viewWidth, 0);
    self.hidden = NO;

    __weak __typeof(self) weakSelf = self;
    weakSelf.alpha = 0;
    [UIView animateWithDuration:0.2
                     animations:^{
                         weakSelf.alpha = 1;
                         weakSelf.maskEffectView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
                         _show = YES;
                     }];
}

- (void)hidenMenuView {
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
    animations:^{
        weakSelf.alpha = 0;
        weakSelf.maskEffectView.frame = CGRectMake(0, viewHeight, viewWidth, 0);
    }
    completion:^(BOOL finished) {
        self.hidden = YES;
        _show = NO;
    }];
}

@end
