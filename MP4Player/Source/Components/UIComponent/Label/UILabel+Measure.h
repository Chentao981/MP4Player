//
//  UILabel+Measure.h
//  StringMeasure
//
//  Created by Chentao on 15/6/19.
//  Copyright (c) 2015年 Chentao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Measure)

- (CGSize)measureSize;

- (CGSize)measureMutableLineSizeWithMaxWidth:(CGFloat)maxWidth lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
