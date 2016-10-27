//
//  CFileBrowseViewController.m
//  MP4Player
//
//  Created by Chentao on 2016/10/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CFileBrowseViewController.h"
#import "CFileBrowseView.h"
#import "CFileBrowseViewFileCell.h"


@interface CFileBrowseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)CFileBrowseView *fileBrowseView;

@property(nonatomic,strong)NSMutableArray <CFile *> *dataSource;

@end

@implementation CFileBrowseViewController{
    BOOL firstLoad;
}

-(NSMutableArray<CFile *> *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(CFileBrowseView *)fileBrowseView{
    return (CFileBrowseView *)self.view;
}

-(void)loadView{
    _fileBrowseView=[[CFileBrowseView alloc]init];
    [_fileBrowseView addEventListenerWithType:FileBrowseView_BackButton_Touch target:self action:@selector(fileBrowseViewBackButtonTouchHandler:)];
    
    [_fileBrowseView.fileListView registerClass:[CFileBrowseViewFileCell class]
                         forCellReuseIdentifier:FileBrowseViewFileCell_Identifier];
    _fileBrowseView.fileListView.delegate=self;
    _fileBrowseView.fileListView.dataSource=self;
    self.view=_fileBrowseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!firstLoad) {
        [self loadDatas];
    }
}

-(void)loadDatas{
    NSString *hudIdentifier=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    [[CHUDManagement sharedInstance] showLoadingHUDWithIdentifier:hudIdentifier text:nil inView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self generationDatas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[CHUDManagement sharedInstance] dismissHUDWithIdentifier:hudIdentifier animated:YES];
            [self.fileBrowseView.fileListView reloadData];
        });
    });
    firstLoad=YES;
}

-(void)generationDatas{
    [self.dataSource removeAllObjects];
    NSArray *files=[HYFileManager listFilesInDirectoryAtPath:self.currentPath deep:NO];
    for (NSString *fileName in files) {
        if ([fileName hasPrefix:@".DS"]) {
            continue;
        }
        
        NSString *fullPath=[self.currentPath stringByAppendingPathComponent:fileName];
        BOOL isDirectory=[HYFileManager isDirectoryAtPath:fullPath];
        
        CFile *file=[[CFile alloc]init];
        file.filePath=fullPath;
        file.fileName=fileName;
        file.isDirectory=isDirectory;

        if (isDirectory) {
            file.image=ImageMake(@"folder_normal");
            [self.dataSource addObject:file];
        }else if([[fileName uppercaseString] hasSuffix:@".MP4"]){
            file.image=[self createKeyFrame:fullPath];
            [self.dataSource addObject:file];
        }else{
            continue;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)fileBrowseViewBackButtonTouchHandler:(CEvent *)event{
    CEvent *backEvent = [[CEvent alloc] initWithType:ViewController_ComeBack andData:nil];
    [self dispatchEvent:backEvent];
}

-(void)setTitle:(NSString *)title{
    self.fileBrowseView.title=title;
}

-(UIImage *)createKeyFrame:(NSString *)videoPath{
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey:@YES };
    AVURLAsset *videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:options];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:videoAsset];
    
    Float64 durationSeconds = CMTimeGetSeconds([videoAsset duration]);
    CMTime midpoint = CMTimeMakeWithSeconds(durationSeconds * 0.5, 600);
    NSError *error;
    CMTime actualTime;
    CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
    return [[UIImage alloc]initWithCGImage:halfWayImage];
}

-(void)setShowBackButton:(BOOL)showBackButton{
    self.fileBrowseView.showBackButton=showBackButton;
}

#pragma mark-UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CFile *file=[self.dataSource objectAtIndex:indexPath.row];
    
    CTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:FileBrowseViewFileCell_Identifier];
    cell.data=file;
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
    
    CFile *file=[self.dataSource objectAtIndex:indexPath.row];
    if (file.isDirectory) {
        CFileBrowseViewController *fileController=[[CFileBrowseViewController alloc]init];
        fileController.currentPath=file.filePath;
        fileController.title=file.fileName;
        fileController.showBackButton=YES;
        [fileController addEventListenerWithType:ViewController_ComeBack
                                          target:self
                                          action:@selector(viewControllerComeBackHandler:)];
        [self.navigationController pushViewController:fileController animated:YES];
    }
}

-(void)viewControllerComeBackHandler:(CEvent *)event{
    [self.navigationController popToViewController:self animated:YES];
}

@end
