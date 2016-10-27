//
//  CTableViewCell.m
//  CoolLibrary
//
//  Created by Chentao on 16/6/19.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CTableViewCell.h"

@implementation CTableViewCell {
    UIView *topLine;
    UIView *bottomLine;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        [self setCellLineProperty];
    }
    return self;
}

- (void)createSubviews {
    topLine = [[UIView alloc] init];
    topLine.backgroundColor = GapLineColor;
    [self.contentView addSubview:topLine];

    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = GapLineColor;
    [self.contentView addSubview:bottomLine];
}

- (void)setCellLineProperty {
    self.showTopLine = NO;
    self.topLineLeftPadding = PageLeftPadding;
    self.topLineRightPadding = 0;
    self.topLineColor = GapLineColor;

    self.showBottomLine = NO;
    self.bottomLineLeftPadding = PageLeftPadding;
    self.bottomLineRightPadding = 0;
    self.bottomLineColor = GapLineColor;
}

- (void)setShowTopLine:(BOOL)showTopLine {
    _showTopLine = showTopLine;
    topLine.hidden = !_showTopLine;
}

- (void)setTopLineLeftPadding:(CGFloat)topLineLeftPadding {
    _topLineLeftPadding = topLineLeftPadding;
    [self setNeedsLayout];
}

- (void)setTopLineRightPadding:(CGFloat)topLineRightPadding {
    _topLineRightPadding = topLineRightPadding;
    [self setNeedsLayout];
}

- (void)setTopLineColor:(UIColor *)topLineColor {
    _topLineColor = topLineColor;
    topLine.backgroundColor = topLineColor;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    bottomLine.hidden = !showBottomLine;
}

- (void)setBottomLineLeftPadding:(CGFloat)bottomLineLeftPadding {
    _bottomLineLeftPadding = bottomLineLeftPadding;
    [self setNeedsLayout];
}

- (void)setBottomLineRightPadding:(CGFloat)bottomLineRightPadding {
    _bottomLineRightPadding = bottomLineRightPadding;
    [self setNeedsLayout];
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    bottomLine.backgroundColor = bottomLineColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);

    [self updateDisplayListViewWidth:viewWidth viewHeight:viewHeight];

    
//    CGFloat xPos = 5;
//    UIView *view = [[UIView alloc] initWithFrame:CGrect(x - SINGLE_LINE_ADJUST_OFFSET, 0, SINGLE_LINE_WIDTH, 100)];

    
    CGFloat lineWidth =SINGLE_LINE_WIDTH;

    CGFloat topLineX = self.topLineLeftPadding;
    CGFloat topLineY = SINGLE_LINE_ADJUST_OFFSET;
    CGFloat topLineW = viewWidth - self.topLineLeftPadding - self.topLineRightPadding;
    CGFloat topLineH = lineWidth;
    topLine.frame = CGRectMake(topLineX, topLineY, topLineW, topLineH);
    [self.contentView bringSubviewToFront:topLine];

    CGFloat bottomLineX = self.bottomLineLeftPadding;
    CGFloat bottomLineY = viewHeight - lineWidth+SINGLE_LINE_ADJUST_OFFSET;
    CGFloat bottomLineW = viewWidth - self.bottomLineLeftPadding - self.bottomLineRightPadding;
    CGFloat bottomLineH = lineWidth;
    bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    [self.contentView bringSubviewToFront:bottomLine];
}

- (void)updateDisplayListViewWidth:(CGFloat)viewWidth viewHeight:(CGFloat)viewHeight {
}

@end
