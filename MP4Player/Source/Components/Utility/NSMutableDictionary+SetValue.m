//
//  NSMutableDictionary+SetValue.m
//  imbangbang
//
//  Created by Chentao on 14/12/22.
//  Copyright (c) 2014年 com.58. All rights reserved.
//

#import "NSMutableDictionary+SetValue.h"

@implementation NSMutableDictionary (SetValue)

- (BOOL)putValue:(id)value forKey:(id<NSCopying>)aKey {
    if (value && aKey) {
        [self setObject:value forKey:aKey];
    } else {
        DEBUG_LOG(@"为字典设置值失败！");
        return NO;
    }
    return YES;
}

@end
