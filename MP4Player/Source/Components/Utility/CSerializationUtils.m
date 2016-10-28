//
//  CSerializationHandler.m
//  AFNetworking3Using
//
//  Created by Chentao on 16/3/2.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CSerializationUtils.h"
@implementation CSerializationUtils

- (NSString *)serializationFilePath:(NSString *)filePath fileName:(NSString *)fileName {
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *cacheFilePath = [CFileUtils createDirectoryWithSuperDirectory:[CFileUtils caches] andPath:identifier];
    NSString *userpath = [CFileUtils createDirectoryWithSuperDirectory:cacheFilePath andPath:filePath];
    NSString *path = [userpath stringByAppendingPathComponent:fileName];
    return path;
}

- (BOOL)archiveObject:(id)obj {
    if (obj) {
        BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:[self serializationFilePath:self.fileDirectory fileName:self.fileName]];
        return success;
    } else {
        return NO;
    }
}

- (id)unarchiveObject {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self serializationFilePath:self.fileDirectory fileName:self.fileName]];
}

@end
