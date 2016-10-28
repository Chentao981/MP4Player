//
//  CVideoFileInfo.h
//  MP4Player
//
//  Created by Chentao on 2016/10/28.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "Jastor.h"

@interface CVideoFileInfo : Jastor

//全路径
@property(nonatomic,copy)NSString *filePath;

//文件名
@property(nonatomic,copy)NSString *fileName;

//info文件名
@property(nonatomic,copy)NSString *videoInfoFileName;

//时长
@property(nonatomic,assign)NSInteger duration;

//观看进度
@property(nonatomic,assign)float progress;


@end
