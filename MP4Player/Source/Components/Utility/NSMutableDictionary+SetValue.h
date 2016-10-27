//
//  NSMutableDictionary+SetValue.h
//  imbangbang
//
//  Created by Chentao on 14/12/22.
//  Copyright (c) 2014年 com.58. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SetValue)

/**
 *设置字典的值，此方法可以避免因为key，value为nil造成的奔溃
 **/
- (BOOL)putValue:(id)value forKey:(id<NSCopying>)aKey;

@end
