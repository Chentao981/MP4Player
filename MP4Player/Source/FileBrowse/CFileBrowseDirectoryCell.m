//
//  CFileBrowseDirectoryCell.m
//  MP4Player
//
//  Created by Chentao on 2016/10/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CFileBrowseDirectoryCell.h"

@implementation CFileBrowseDirectoryCell{
    UIImageView *iconView;
    UILabel *titleLabel;
    UIScrollView *scrollContentView;
}


-(void)createSubviews{
    [super createSubviews];
    self.backgroundColor=[UIColor whiteColor];
    
    scrollContentView=[[UIScrollView alloc]init];
    scrollContentView.alwaysBounceHorizontal=YES;
    [self.contentView addSubview:scrollContentView];
    
    iconView=[[UIImageView alloc]init];
    iconView.image=ImageMake(@"folder_normal");
    [scrollContentView addSubview:iconView];
    
    titleLabel=[[UILabel alloc]init];
    titleLabel.textColor=SteelColor;
    titleLabel.text=@"测试";
    titleLabel.font=FontMake(15);
    [scrollContentView addSubview:titleLabel];
}

-(void)updateDisplayListViewWidth:(CGFloat)viewWidth viewHeight:(CGFloat)viewHeight{
    [super updateDisplayListViewWidth:viewWidth viewHeight:viewHeight];
    
    scrollContentView.frame=CGRectMake(0, 0, viewWidth, viewHeight);
    
    CGSize iconViewSize=iconView.image.size;
    CGFloat iconViewX=PageLeftPadding;
    CGFloat iconViewY=0.5*(viewHeight-iconViewSize.height);
    iconView.frame=CGRectMake(iconViewX, iconViewY, iconViewSize.width, iconViewSize.height);
    
    CGSize titleLabelSize=[titleLabel measureSize];
    CGFloat titleLabelX=CGRectGetMaxX(iconView.frame)+20;
    CGFloat titleLabelY=0.5*(viewHeight-titleLabelSize.height);
    titleLabel.frame=CGRectMake(titleLabelX, titleLabelY, titleLabelSize.width, titleLabelSize.height);
}

@end
