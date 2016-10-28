//
//  CSerializationHandler.h
//  AFNetworking3Using
//
//  Created by Chentao on 16/3/2.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用于序列化一个对象到 Caches 目录
 */
@interface CSerializationUtils : NSObject

/**
 *  文件的上一级目录
 */
@property (nonatomic, copy) NSString *fileDirectory;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  序列化对象
 *
 *  @param obj
 *
 *  @return
 */
- (BOOL)archiveObject:(id)obj;

/**
 *  反序列化对象
 *
 *  @return
 */
- (id)unarchiveObject;

@end
