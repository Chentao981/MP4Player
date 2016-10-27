//
//  UtilityMacro.h
//  CoolLibrary
//
//  Created by Chentao on 16/1/2.
//  Copyright © 2016年 Chentao. All rights reserved.
//  常用变量和方法

#ifndef UtilityMacro_h
#define UtilityMacro_h

// DEBUG_LOG
#ifdef DEBUG
#define DEBUG_LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DEBUG_LOG(...)
#endif

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

// UIImage
#define ImageMake(name) [UIImage imageNamed:name]

// UIFont
#define FontMake(size) [UIFont systemFontOfSize:size]
#define BoldFontMake(size) [UIFont boldSystemFontOfSize:size]

// UIColor
#define ColorMake(rgb) [UIColor colorWithHex:rgb]
#define ColorAlphaMake(rgb, a) [UIColor colorWithHex:rgb alpha:a]

// AppDelegate
#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// AppShortVersion
#define AppShortVersion [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]

#endif /* UtilityMacro_h */
