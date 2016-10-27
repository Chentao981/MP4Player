//
//  CHUDManagement.h
//
//  Created by Chentao on 16/9/13.
//  Copyright © 2016年 com.KaoChong. All rights reserved.
//

#import "CHUD.h"
#import <Foundation/Foundation.h>


@interface CHUDManagement : NSObject

+ (CHUDManagement *_Nullable)sharedInstance;

#pragma mark - Base

- (void)dismissHUDWithIdentifier:(nonnull NSString *)identifier animated:(BOOL)animated;

- (void)dismissHUD:(nonnull CHUD *)hud animated:(BOOL)animated;

- (CHUD *_Nullable)getHUDWithIdentifier:(nonnull NSString *)identifier;

#pragma mark - Toast

- (CHUD *_Nullable)showToastWithMessage:(nonnull NSString *)message
                      inView:(nonnull UIView *)view
                       delay:(NSTimeInterval)delay
           didDismissHandler:(nullable ProgressHUDDidDismissHandler)didDismissHandler;


- (CHUD *_Nullable)showToastWithMessage:(nonnull NSString *)message
                       didDismissHandler:(nullable ProgressHUDDidDismissHandler)didDismissHandler;

- (CHUD *_Nullable)showToastWithMessage:(nonnull NSString *)message
                                   delay:(NSTimeInterval)delay
                       didDismissHandler:(nullable ProgressHUDDidDismissHandler)didDismissHandler;

- (CHUD *_Nullable)showFailureHUDWithMessage:(nonnull NSString *)message
                                   completion:(nullable ProgressHUDDidDismissHandler)completionHandler;

- (CHUD *_Nullable)showFailureHUDWithMessage:(nonnull NSString *)message
                                        delay:(NSTimeInterval)delay
                                   completion:(nullable ProgressHUDDidDismissHandler)completionHandler;

- (CHUD *_Nullable)showSuccessHUDWithMessage:(nonnull NSString *)message
                                   completion:(nullable ProgressHUDDidDismissHandler)completionHandler;

- (CHUD *_Nullable)showSuccessHUDWithMessage:(nonnull NSString *)message
                                        delay:(NSTimeInterval)delay
                                   completion:(nullable ProgressHUDDidDismissHandler)completionHandler;

#pragma mark - Loading

- (CHUD *_Nullable)showLoadingHUDWithIdentifier:(nullable NSString *)identifier
                                            text:(nullable NSString *)text
                                          inView:(nonnull UIView *)view;

- (CHUD *_Nullable)showLoadingHUDWithIdentifier:(nullable NSString *)identifier
                                            text:(nullable NSString *)text
                                          inView:(nonnull UIView *)view
                               didDismissHandler:(nullable ProgressHUDDidDismissHandler)didDismissHandler;




@end
