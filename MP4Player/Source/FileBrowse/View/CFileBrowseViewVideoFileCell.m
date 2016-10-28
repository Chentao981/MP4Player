//
//  CFileBrowseViewVideoFileCell.m
//  MP4Player
//
//  Created by Chentao on 2016/10/28.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CFileBrowseViewVideoFileCell.h"
#import "CFile.h"

@implementation CFileBrowseViewVideoFileCell{
    UIImageView *iconView;
    UILabel *titleLabel;
    
    UILabel *durationLabel;
    
    //    UIScrollView *scrollContentView;
}


-(void)createSubviews{
    [super createSubviews];
    self.backgroundColor=[UIColor whiteColor];
    
    //    scrollContentView=[[UIScrollView alloc]init];
    //    scrollContentView.delegate=self;
    //    scrollContentView.showsHorizontalScrollIndicator=NO;
    //    scrollContentView.alwaysBounceHorizontal=YES;
    //    [self.contentView addSubview:scrollContentView];
    
    iconView=[[UIImageView alloc]init];
    //    iconView.layer.borderColor=GapLineColor.CGColor;
    //    iconView.layer.borderWidth=0.5;
    iconView.clipsToBounds=YES;
    iconView.contentMode=UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconView];
    
    titleLabel=[[UILabel alloc]init];
    titleLabel.textColor=SteelColor;
    titleLabel.font=FontMake(15);
    [self.contentView addSubview:titleLabel];
    
    
    durationLabel=[[UILabel alloc]init];
    durationLabel.textColor=LightGrayColor;
    durationLabel.font=FontMake(13);
    [self.contentView addSubview:durationLabel];
}


-(void)setData:(id)data{
    [super setData:data];
    CFile *file=(CFile *)self.data;
    titleLabel.text=file.fileName;
    durationLabel.text=file.durationText;
    iconView.image=file.image;
    [self setNeedsLayout];
}


-(void)updateDisplayListViewWidth:(CGFloat)viewWidth viewHeight:(CGFloat)viewHeight{
    [super updateDisplayListViewWidth:viewWidth viewHeight:viewHeight];
    
    //    scrollContentView.frame=CGRectMake(0, 0, viewWidth, viewHeight);
    //    scrollContentView.contentSize=CGSizeMake(viewWidth+100, viewHeight);
    
    CGFloat iconViewWidth=94;
    CGFloat iconViewHeight=70;
    CGFloat iconViewX=PageLeftPadding;
    CGFloat iconViewY=0.5*(viewHeight-iconViewHeight);
    iconView.frame=CGRectMake(iconViewX, iconViewY, iconViewWidth, iconViewHeight);
    
    CGFloat gap=15;
    CGSize titleLabelSize=[titleLabel measureSize];
    CGSize durationLabelSize= [durationLabel measureSize];
    
    CGFloat titleLabelX=CGRectGetMaxX(iconView.frame)+20;
    CGFloat titleLabelY=0.5*(viewHeight-titleLabelSize.height-durationLabelSize.height-gap);
    
    CGFloat titleLabelMaxWidth=viewWidth-PageRightPadding-titleLabelX;
    if (titleLabelSize.width>titleLabelMaxWidth) {
        titleLabelSize.width=titleLabelMaxWidth;
    }
    
    if (durationLabelSize.width>titleLabelMaxWidth) {
        durationLabelSize.width=titleLabelMaxWidth;
    }
    
    
    titleLabel.frame=CGRectMake(titleLabelX, titleLabelY, titleLabelSize.width, titleLabelSize.height);

    CGFloat durationLabelX=titleLabelX;
    CGFloat durationLabelY=CGRectGetMaxY(titleLabel.frame)+gap;
    durationLabel.frame=CGRectMake(durationLabelX, durationLabelY, durationLabelSize.width, durationLabelSize.height);
}

//#pragma mark-UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    //NSLog(@"%s  %f",__FUNCTION__ , scrollView.contentOffset.x);
//
////    if (scrollView.contentOffset.x>100) {
////        CGPoint contentOffset=scrollView.contentOffset;
////        contentOffset.x=100;
////        scrollView.contentOffset=contentOffset;
//////        scrollView.scrollEnabled=NO;
////    }
//}
//
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"%s",__FUNCTION__);
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    NSLog(@"%s",__FUNCTION__);
//}


@end
