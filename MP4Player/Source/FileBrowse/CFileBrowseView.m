//
//  CFileBrowseView.m
//  MP4Player
//
//  Created by Chentao on 2016/10/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CFileBrowseView.h"



@implementation CFileBrowseView{
    Group *topView;
    UILabel *titleLabel;
    UIButton *backButton;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

-(void)createSubviews{
    CGFloat topViewHeight=70;
    
    _fileListView=[[CTableView alloc]init];
    _fileListView.backgroundColor=AntiFlashWhiteColor;
    _fileListView.includeInLayout=YES;
    _fileListView.layout_left=[NSNumber numberWithFloat:0.0];
    _fileListView.layout_right=[NSNumber numberWithFloat:0.0];
    _fileListView.layout_top=[NSNumber numberWithFloat:topViewHeight];
    _fileListView.layout_bottom=[NSNumber numberWithFloat:0.0];
    [self addSubview:_fileListView];
    
    topView=[[Group alloc]init];
    topView.layer.shadowColor=SteelColor.CGColor;
    topView.layer.shadowOffset=CGSizeMake(0, 4);
    topView.layer.shadowOpacity = 0.4;
    topView.backgroundColor=CeruleanColor;
    topView.layout_height=topViewHeight;
    topView.includeInLayout=YES;
    topView.layout_left=[NSNumber numberWithFloat:0.0];
    topView.layout_right=[NSNumber numberWithFloat:0.0];
    topView.layout_top=[NSNumber numberWithFloat:0.0];
    [self addSubview:topView];
    
    titleLabel=[[UILabel alloc]init];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=ColorMake(0xFFFFFF);
    titleLabel.font=BoldFontMake(16);
    titleLabel.includeInLayout=YES;
    titleLabel.layout_left=[NSNumber numberWithFloat:50.0];
    titleLabel.layout_right=[NSNumber numberWithFloat:50.0];
    titleLabel.layout_top=[NSNumber numberWithFloat:20.0];
    titleLabel.layout_bottom=[NSNumber numberWithFloat:20.0];
    [topView addSubview:titleLabel];
    
    backButton=[[UIButton alloc]init];
    [backButton addTarget:self action:@selector(backButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    backButton.layout_width=50;
    backButton.layout_height=50;
    [backButton setImage:ImageMake(@"backbutton_normal") forState:UIControlStateNormal];
    backButton.includeInLayout=YES;
    backButton.layout_left=[NSNumber numberWithFloat:0.0];
    backButton.layout_verticalCenter=[NSNumber numberWithFloat:0.0];
    [topView addSubview:backButton];
}

-(void)setTitle:(NSString *)title{
    titleLabel.text=title;
}


-(void)backButtonTouchHandler{

    NSLog(@"backButtonTouchHandler");

}

@end
