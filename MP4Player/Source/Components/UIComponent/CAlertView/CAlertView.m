//
//  SCAlertView.m
//  SuperCoach
//
//  Created by Chentao on 15/11/8.
//  Copyright © 2015年 Lin Feihong. All rights reserved.
//

#import "CAlertView.h"

@interface CAlertView () <UIAlertViewDelegate>

@end

@implementation CAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoDismiss = YES;
        self.delegate = self;
    }
    return self;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (self.autoDismiss) {
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
}

#pragma mark -UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    CEvent *event = [[CEvent alloc] initWithType:AlertView_ClickedButton andData:[NSNumber numberWithInteger:buttonIndex]];
    [self dispatchEvent:event];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    CEvent *event =
    [[CEvent alloc] initWithType:AlertView_ClickedButtonWillDismiss andData:[NSNumber numberWithInteger:buttonIndex]];
    [self dispatchEvent:event];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    CEvent *event =
    [[CEvent alloc] initWithType:AlertView_ClickedButtonDidDismiss andData:[NSNumber numberWithInteger:buttonIndex]];
    [self dispatchEvent:event];
}

@end
