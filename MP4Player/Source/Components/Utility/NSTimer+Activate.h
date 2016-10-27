//
//  NSTimer+Activate.h
//  CoolLibrary
//
//  Created by Chentao on 16/3/9.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Activate)

/**
 *  暂停
 */
- (void)pauseTimer;

/**
 *  恢复
 */
- (void)resumeTimer;

/**
 *  指定时间后恢复
 *
 *  @param interval 间隔时间
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
