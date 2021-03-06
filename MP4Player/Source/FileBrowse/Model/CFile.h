//
//  CFile.h
//  MP4Player
//
//  Created by Chentao on 2016/10/27.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "Jastor.h"

@interface CFile : Jastor

//全路径
@property(nonatomic,copy)NSString *filePath;

//文件名
@property(nonatomic,copy)NSString *fileName;

//是否是目录
@property(nonatomic,assign)BOOL isDirectory;

//icon
@property(nonatomic,strong)UIImage *image;

//时长
@property(nonatomic,assign)NSInteger duration;

//格式化时长 00:00:00
@property(nonatomic,copy)NSString *durationText;


@end
