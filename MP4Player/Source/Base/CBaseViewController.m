//
//  CBaseViewController.m
//  MP4Player
//
//  Created by Chentao on 2016/10/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CBaseViewController.h"

NSString *const ViewController_ComeBack = @"ViewController_ComeBack";


@interface CBaseViewController ()

@end

@implementation CBaseViewController


//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setNavigationBarProperty];
//}
//
///**
// *  设置NavigationBar属性
// */
//- (void)setNavigationBarProperty {
//    self.navigationController.navigationBar.clipsToBounds = YES;
//    self.navigationController.navigationBar.hidden = NO;
////    self.navigationController.navigationBar.clipsToBounds = NO;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = CeruleanColor;
//    [self.navigationItem setHidesBackButton:YES]; // 返回按钮隐藏
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


@end
