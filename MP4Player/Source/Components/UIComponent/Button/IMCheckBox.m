//
//  IMCheckBox.m
//  IMRadioButtonUseing
//
//  Created by Chentao on 14/10/22.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "IMCheckBox.h"
#define ICON_WIDTH 20.0
#define ICON_HEIGHT 20.0

@interface IMCheckBox ()
@property (nonatomic, strong) UIImageView *iconView;
@end

@implementation IMCheckBox {
    CGRect labelFrame;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.measureSize = YES;
        self.backgroundColor = [UIColor clearColor];

        self.normIcon = [UIImage imageNamed:@"orange_checkbox_normal"];
        self.selectedIcon = [UIImage imageNamed:@"orange_checkbox_select"];
        self.gap = 3;

        self.iconView = [[UIImageView alloc] init];
        self.labelFont = [UIFont systemFontOfSize:13];
        self.labelColor = [UIColor blackColor];
        self.selectedLabelColor = [UIColor blackColor];
        [self addSubview:self.iconView];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHandler)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)setLabelColor:(UIColor *)labelColor {
    _labelColor = labelColor;
    [self setNeedsDisplay];
}

- (void)touchHandler {
    self.selected = !self.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkBoxOnTouch:)]) {
        [self.delegate checkBoxOnTouch:self];
    }
}

- (void)setNormIcon:(UIImage *)normIcon {
    _normIcon = normIcon;
    [self setNeedsDisplay];
}

- (void)setSelectedIcon:(UIImage *)selectedIcon {
    _selectedIcon = selectedIcon;
    [self setNeedsDisplay];
}

- (void)setLabelText:(NSString *)labelText {
    _labelText = [labelText copy];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    if (_selected ^ selected) {
        _selected = selected;
        //选择状态发生变化
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkBoxOnSelectedChange:)]) {
            [self.delegate checkBoxOnSelectedChange:self];
        }
        // NSLog(@"选择状态发生变化:%d", _selected);
        [self setNeedsDisplay];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    CGFloat gap = 3;
    if (self.measureSize) {
        CGSize labelTextSize = [self measureTextSizeWithText:_labelText andFont:self.labelFont];

        CGFloat h = labelTextSize.height;
        CGFloat labelY = 0;

        if (h < ICON_HEIGHT) {
            labelY = 0.5 * (ICON_HEIGHT - h);
            h = ICON_HEIGHT;
        }

        labelFrame = CGRectMake(ICON_WIDTH + self.gap, labelY, labelTextSize.width, labelTextSize.height);
        CGFloat w = ICON_WIDTH + self.gap + labelTextSize.width;

        CGFloat oldWidth = self.frame.size.width;
        CGFloat oldHeight = self.frame.size.height;

        CGRect newFrame = self.frame;
        newFrame.size.width = w;
        newFrame.size.height = h;
        self.frame = newFrame;

        if (w != oldWidth || h != oldHeight) {
            if (self.superview) {
                [self.superview setNeedsLayout];
            }
        }
    } else {
        CGSize labelTextSize = [self measureTextSizeWithText:_labelText andFont:self.labelFont];
        CGFloat labelY = 0.5 * (self.frame.size.height - labelTextSize.height);
        labelFrame = CGRectMake(ICON_WIDTH + self.gap, labelY, self.frame.size.width - (ICON_WIDTH + self.gap), labelTextSize.height);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.selected) {
        self.iconView.image = self.selectedIcon;
        self.iconView.frame = CGRectMake(0, 0.5 * (rect.size.height - ICON_HEIGHT), ICON_WIDTH, ICON_HEIGHT);
        //增加动画效果
        if (self.selectedShowAnimation) {
            [self showAnimationWithView:self.iconView];
        }
    } else {
        self.iconView.image = self.normIcon;
        self.iconView.frame = CGRectMake(0, 0.5 * (rect.size.height - ICON_HEIGHT), ICON_WIDTH, ICON_HEIGHT);
    }

    if (_labelText) {
        if (self.selected) {
            [self.selectedLabelColor setFill];
            [_labelText drawInRect:labelFrame withAttributes:@{ NSFontAttributeName: self.labelFont, NSForegroundColorAttributeName: self.selectedLabelColor }];
        } else {
            [self.labelColor setFill];
            [_labelText drawInRect:labelFrame withAttributes:@{ NSFontAttributeName: self.labelFont, NSForegroundColorAttributeName: self.labelColor }];
        }
        //        if (self.selected) {
        //            [self.selectedLabelColor setFill];
        //        } else {
        //            [self.labelColor setFill];
        //        }
        //        [_labelText drawInRect:labelFrame withFont:self.labelFont];
    }
}

- (CGSize)measureTextSizeWithText:(NSString *)text andFont:(UIFont *)font {
    // return [text sizeWithFont:font];
    return [text sizeWithAttributes:@{ NSFontAttributeName: font }];
}

- (void)showAnimationWithView:(UIView *)view {
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:2.5:2.5:0.4:0.4];
    animation.keyPath = @"bounds";
    CGRect oldBounds = view.layer.bounds;
    NSUInteger frameSize = 30;
    CGFloat timeGap = 1.0f / (frameSize * 1.0f);
    NSMutableArray *animationValues = [[NSMutableArray alloc] initWithCapacity:frameSize];
    for (NSUInteger i = 0; i < frameSize; i++) {
        CGFloat x = (i + 1) * timeGap;
        CGFloat temp = sin(2 * M_PI * x);
        if (temp < 0) {
            temp = -temp;
        }
        CGFloat increment = 3.0 * temp / (3 * x);
        NSValue *newFrame = [NSValue valueWithCGRect:CGRectMake(oldBounds.origin.x, oldBounds.origin.y, oldBounds.size.width + increment, oldBounds.size.height + increment)];
        [animationValues addObject:newFrame];
    }
    animation.values = animationValues;
    [view.layer addAnimation:animation forKey:@"bounds"];
}

@end
