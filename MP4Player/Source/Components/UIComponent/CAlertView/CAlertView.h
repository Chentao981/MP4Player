//
//  SCAlertView.h
//  SuperCoach
//
//  Created by Chentao on 15/11/8.
//  Copyright © 2015年 Lin Feihong. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -Event

#define AlertView_ClickedButton @"AlertView_ClickedButton"

#define AlertView_ClickedButtonWillDismiss @"AlertView_ClickedButtonWillDismiss"

#define AlertView_ClickedButtonDidDismiss @"AlertView_ClickedButtonDidDismiss"

@interface CAlertView : UIAlertView

/**
 *  是否自动隐藏
 */
@property (nonatomic, assign) BOOL autoDismiss;

@property (nonatomic, strong) id userInfo;

@end
