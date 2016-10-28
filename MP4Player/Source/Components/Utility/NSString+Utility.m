//
//  NSString+Utility.m
//  MP4Player
//
//  Created by Chentao on 2016/10/28.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "NSString+Utility.h"
#include <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8


@implementation NSString (Utility)


+ (NSString *)timeIntervalFormat:(unsigned long long)time {
    unsigned long long second = time % 60;
    unsigned long long minute = (time / 60) % 60;
    unsigned long long hour = time / 3600;
    
    NSString *secondText = [NSString stringWithFormat:@"%llu", second];
    if (second < 10) {
        secondText = [NSString stringWithFormat:@"0%llu", second];
    }
    
    NSString *minuteText = [NSString stringWithFormat:@"%llu", minute];
    if (minute < 10) {
        minuteText = [NSString stringWithFormat:@"0%llu", minute];
    }
    
    NSString *hourText = [NSString stringWithFormat:@"%llu", hour];
    if (hour < 10) {
        hourText = [NSString stringWithFormat:@"0%llu", hour];
    }
    
    NSString *timeText = [NSString stringWithFormat:@"%@:%@:%@", hourText, minuteText, secondText];
    return timeText;
}

-(NSString *)getMD5{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)self, FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    CFURLRef fileURL =CFURLCreateWithFileSystemPath(kCFAllocatorDefault,(CFStringRef)filePath,kCFURLPOSIXPathStyle,(Boolean)false);
    
    if (!fileURL) goto done;
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,(CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    CC_MD5_CTX hashObject;
    
    CC_MD5_Init(&hashObject);
    
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    didSucceed = !hasMoreData;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    if (!didSucceed) goto done;
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    
    if (fileURL) {
        CFRelease(fileURL);
    }
    
    return result;
    
}

@end
