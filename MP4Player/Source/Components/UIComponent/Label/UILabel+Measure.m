//
//  UILabel+Measure.m
//  StringMeasure
//
//  Created by Chentao on 15/6/19.
//  Copyright (c) 2015年 Chentao. All rights reserved.
//

#import "UILabel+Measure.h"

@implementation UILabel (Measure)


- (CGSize)measureSize {
	NSDictionary *attributes = @{ NSFontAttributeName: self.font };
	CGSize measureSize = [self.text sizeWithAttributes:attributes];
	return measureSize;
}

- (CGSize)measureMutableLineSizeWithMaxWidth:(CGFloat)maxWidth lineBreakMode:(NSLineBreakMode)lineBreakMode {
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineBreakMode = lineBreakMode;
	NSDictionary *attributes = @{ NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy };
	CGSize measureSize = [self.text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
	return measureSize;
}

@end
