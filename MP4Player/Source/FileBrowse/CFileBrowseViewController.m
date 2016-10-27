//
//  CFileBrowseViewController.m
//  MP4Player
//
//  Created by Chentao on 2016/10/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CFileBrowseViewController.h"
#import "CFileBrowseView.h"
#import "CFileBrowseDirectoryCell.h"

@interface CFileBrowseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)CFileBrowseView *fileBrowseView;

@end

@implementation CFileBrowseViewController

-(CFileBrowseView *)fileBrowseView{
    return (CFileBrowseView *)self.view;
}

-(void)loadView{
    _fileBrowseView=[[CFileBrowseView alloc]init];
    [_fileBrowseView.fileListView registerClass:[CFileBrowseDirectoryCell class]
                         forCellReuseIdentifier:FileBrowseDirectoryCell_Identifier];
    _fileBrowseView.fileListView.delegate=self;
    _fileBrowseView.fileListView.dataSource=self;
    self.view=_fileBrowseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title=@"测试 123 ";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)setTitle:(NSString *)title{
    self.fileBrowseView.title=title;
}

#pragma mark-UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:FileBrowseDirectoryCell_Identifier];
    cell.showBottomLine=YES;
    cell.bottomLineLeftPadding=0;
    cell.bottomLineRightPadding=0;
    return cell;
}

#pragma mark-UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 98;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
