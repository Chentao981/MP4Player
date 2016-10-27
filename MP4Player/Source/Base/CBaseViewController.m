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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addEventListenerWithType:ViewController_ComeBack target:self action:@selector(controllerComeBackHandler:)];
    
    [self setNavigationBarProperty];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)controllerComeBackHandler:(CEvent *)event {
    UIViewController *viewController = event.dispatcherOwner;
    [viewController removeAllEventListener];
    [viewController.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


/**
 *  设置NavigationBar属性
 */
- (void)setNavigationBarProperty {
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.clipsToBounds = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = CeruleanColor;
    [self.navigationItem setHidesBackButton:YES]; // 返回按钮隐藏
}

#pragma mark - BarButtonItem

- (void)addLeftBarButtonItems:(UIBarButtonItem *)leftBarButton {
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)addRightBarButtonItems:(UIBarButtonItem *)rightBarButton {
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)showBackButton {
    [self setLeftItemWithImageName:@"backbutton_normal"
              highlightedImageName:@"backbutton_normal"
                            action:@selector(backButtonTouchHandler)];
}

- (void)backButtonTouchHandler {
    CEvent *event = [[CEvent alloc] initWithType:ViewController_ComeBack andData:nil];
    [self dispatchEvent:event];
}

- (UIButton *)setLeftItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)heighlightedImageName action:(SEL)action {
    UIImage *normalImage =[UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGSize buttonSize = CGSizeMake(40, 40);
    CGSize normalImageSize = normalImage.size;
    
    CGFloat imageTop = 0.5 * (buttonSize.height - normalImageSize.height);
    CGFloat imageBottom = imageTop;
    CGFloat imageCenterX = 0.5 * (buttonSize.width - normalImageSize.width);
    CGFloat imageLeft = imageCenterX - 15;
    CGFloat imageRight = imageCenterX + 15;
    [button setImageEdgeInsets:UIEdgeInsetsMake(imageTop, imageLeft, imageBottom, imageRight)];
    
    button.frame = CGRectMake(0, 0, buttonSize.height, buttonSize.width);
    
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:heighlightedImageName] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self addLeftBarButtonItems:item];
    return button;
}

- (UIButton *)setRightItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)heighlightedImageName action:(SEL)action {
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGSize buttonSize = CGSizeMake(40, 40);
    CGSize normalImageSize = normalImage.size;
    
    CGFloat imageTop = 0.5 * (buttonSize.height - normalImageSize.height);
    CGFloat imageBottom = imageTop;
    CGFloat imageCenterX = 0.5 * (buttonSize.width - normalImageSize.width);
    CGFloat imageLeft = imageCenterX + 15;
    CGFloat imageRight = imageCenterX - 15;
    [button setImageEdgeInsets:UIEdgeInsetsMake(imageTop, imageLeft, imageBottom, imageRight)];
    button.frame = CGRectMake(0, 0, buttonSize.height, buttonSize.width);
    
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:heighlightedImageName] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self addRightBarButtonItems:item];
    
    return button;
}

- (UIButton *)setLeftItemWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    float width = [button.titleLabel measureSize].width;
    button.frame = CGRectMake(0, 0, width, 40);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self addLeftBarButtonItems:item];
    return button;
}

- (UIButton *)setRightItemWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    float width = [button.titleLabel measureSize].width;
    button.frame = CGRectMake(0, 0, width, 40);
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self addRightBarButtonItems:item];
    return button;
}

@end
