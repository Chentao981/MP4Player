//
//  NSDate+Format.h
//  CoolLibrary
//
//  Created by Chentao on 16/7/31.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Format_Year_Month_Day @"yyyy-MM-dd"

@interface NSDate (Format)

+ (instancetype)dateWithTimeIntervalMillisecond:(NSTimeInterval)millisecond;

- (NSString *)dateToStringWithFormat:(NSString *)format;

@end
