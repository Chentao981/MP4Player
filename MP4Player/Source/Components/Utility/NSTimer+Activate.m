//
//  NSTimer+Activate.m
//  CoolLibrary
//
//  Created by Chentao on 16/3/9.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "NSTimer+Activate.h"

@implementation NSTimer (Activate)

- (void)pauseTimer {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
