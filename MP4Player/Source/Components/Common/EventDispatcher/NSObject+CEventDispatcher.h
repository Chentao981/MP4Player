//
//  NSObject+EventDispatcher.h
//  EventDispatcher
//
//  Created by Chentao on 15/6/22.
//  Copyright (c) 2015年 Chentao. All rights reserved.
//

#import "CEvent.h"
#import <Foundation/Foundation.h>

@interface NSObject (CEventDispatcher)

/**
 *  添加一个事件监听器,默认优先级为1
 *
 *  @param type     事件类型
 *  @param target   事件的响应者 target使用weak方式管理，避免内存不释放的问题出现
 *  @param action   响应者的方法 方法的格式如: -(void)action:(CEvent *)event;
 *  @param priority 监听器的优先级
 */
- (void)addEventListenerWithType:(NSString *)type target:(id)target action:(SEL)action priority:(NSUInteger)priority;


/**
 *  添加一个事件监听器
 *
 *  @param type     时间类型
 *  @param target   事件的响应者 target使用weak方式管理，避免内存不释放的问题出现
 *  @param action   响应者的方法 方法的格式如: -(void)action:(CEvent *)event;
 */
- (void)addEventListenerWithType:(NSString *)type target:(id)target action:(SEL)action;

/**
 *  派发一个事件
 *
 *  @param event 事件
 */
- (void)dispatchEvent:(CEvent *)event;

/**
 *  移除事件监听
 *
 *  @param type 事件类型
 *  @param target 事件的响应者
 *  @param action 响应者的方法
 */
- (void)removeEventListenerWithType:(NSString *)type target:(id)target action:(SEL)action;

/**
 *  移除所有事件监听
 */
- (void)removeAllEventListener;

@end
