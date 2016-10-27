//
//  CRootNavigationController.m
//  MP4Player
//
//  Created by Chentao on 2016/10/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CRootNavigationController.h"
#import "CFileBrowseViewController.h"

@interface CRootNavigationController ()

@end

@implementation CRootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+(CRootNavigationController *)rootNavigationController{
    CFileBrowseViewController *documentDirectoryViewController=[[CFileBrowseViewController alloc]init];
    documentDirectoryViewController.currentPath=[HYFileManager documentsDir];
    documentDirectoryViewController.title=@"本地文件";

    CRootNavigationController *rootNavigationController=[[CRootNavigationController alloc]initWithRootViewController:documentDirectoryViewController];
    
    return rootNavigationController;
}


@end
