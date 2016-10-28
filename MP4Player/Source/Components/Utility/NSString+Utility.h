//
//  NSString+Utility.h
//  MP4Player
//
//  Created by Chentao on 2016/10/28.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

/**
 * 格式化时间 输入：秒数 输出：00:00:00
 **/
+ (NSString *)timeIntervalFormat:(unsigned long long)time ;

/**
 *获取文件MD5
 **/
-(NSString*)getMD5;

@end
