//
//  CFileBrowseDirectoryCell.m
//  MP4Player
//
//  Created by Chentao on 2016/10/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CFileBrowseViewFileCell.h"

@interface CFileBrowseViewFileCell()

@end

@implementation CFileBrowseViewFileCell{
    UIImageView *iconView;
    UILabel *titleLabel;
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
    iconView.clipsToBounds=YES;
    iconView.contentMode=UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconView];
    
    titleLabel=[[UILabel alloc]init];
    titleLabel.textColor=SteelColor;
    titleLabel.font=FontMake(15);
    [self.contentView addSubview:titleLabel];
}


-(void)setData:(id)data{
    [super setData:data];
    CFile *file=(CFile *)self.data;
    titleLabel.text=file.fileName;
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
    
    CGSize titleLabelSize=[titleLabel measureSize];
    CGFloat titleLabelX=CGRectGetMaxX(iconView.frame)+20;
    CGFloat titleLabelY=0.5*(viewHeight-titleLabelSize.height);
    titleLabel.frame=CGRectMake(titleLabelX, titleLabelY, titleLabelSize.width, titleLabelSize.height);
    
    
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
