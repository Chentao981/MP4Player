//
//  NSDate+Format.m
//  CoolLibrary
//
//  Created by Chentao on 16/7/31.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

+ (instancetype)dateWithTimeIntervalMillisecond:(NSTimeInterval)millisecond {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millisecond / 1000.0];
    return date;
}

- (NSString *)dateToStringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}

@end
