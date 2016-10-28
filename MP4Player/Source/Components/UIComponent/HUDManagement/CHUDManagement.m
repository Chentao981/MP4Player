//
//  CHUDManagement.m
//
//  Created by Chentao on 16/9/13.
//  Copyright © 2016年 com.KaoChong. All rights reserved.
//

#import "CHUDManagement.h"
#import "CLoadingHUDIndicatorView.h"
#import "AppDelegate.h"
#import "CPromptHUDIndicatorView.h"
#import "CSuccessHUDIndicatorView.h"

#define ToastDelay 1.0

@interface CHUDManagement () <JGProgressHUDDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSString *, CHUD *> *huds;

@end

@implementation CHUDManagement

static CHUDManagement *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copy {
    return [[CHUDManagement alloc] init];
}

- (id)mutableCopy {
    return [[CHUDManagement alloc] init];
}

- (id)init {
    if (SINGLETON) {
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}

#pragma mark -
- (NSMutableDictionary *)huds {
    if (!_huds) {
        _huds = [[NSMutableDictionary alloc] init];
    }
    return _huds;
}

- (CHUD *)createHUDWithIdentifier:(NSString *)identifier {
    if (!identifier || 0 == identifier.length) {
        NSDate *nowDate = [NSDate date];
        NSTimeInterval timeInterval = nowDate.timeIntervalSince1970 * 1000;
        identifier = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:timeInterval]];
    }
    
    CHUD *hud = [self getHUDWithIdentifier:identifier];
    if (!hud) {
        hud = [[CHUD alloc] init];
        hud.delegate = self;
        hud.identifier = identifier;
        
        [self.huds setObject:hud forKey:hud.identifier];
        
        hud.marginInsets = UIEdgeInsetsMake(40, 40, 40, 40);
        hud.contentInsets = UIEdgeInsetsMake(16, 30, 16, 30);
        hud.indicatorView = nil;
        
        JGProgressHUDFadeAnimation *animation = [JGProgressHUDFadeAnimation animation];
        hud.animation = animation;
        
        hud.HUDView.backgroundColor = [UIColor whiteColor];
        hud.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
        hud.HUDView.layer.shadowOffset = CGSizeMake(0, 2);
        hud.HUDView.layer.shadowOpacity = 0.2f;
        hud.HUDView.layer.shadowRadius = 2.0f;
        hud.textLabel.font = [UIFont systemFontOfSize:15];
        hud.textLabel.textColor = [UIColor blackColor];
    }
    return hud;
}

#pragma mark -Base

- (void)dismissHUDWithIdentifier:(NSString *)identifier animated:(BOOL)animated {
    CHUD *hud = [self.huds objectForKey:identifier];
    [self dismissHUD:hud animated:animated];
}

- (void)dismissHUD:(CHUD *)hud animated:(BOOL)animated {
    [hud dismissAnimated:animated];
}

- (CHUD *)getHUDWithIdentifier:(NSString *)identifier {
    return [self.huds objectForKey:identifier];
}

- (void)clearDiscardHUD {
    NSArray *hudArray = [self.huds allValues];
    NSInteger hudCount = hudArray.count;
    for (NSInteger index = hudCount - 1; index >= 0; index--) {
        CHUD *hud = [hudArray objectAtIndex:index];
        if (!hud.superview) {
            [self.huds removeObjectForKey:hud.identifier];
        }
    }
}

-(UIWindow *)mainWindow{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow= appDelegate.window;
    return mainWindow;
}

#pragma mark - Toast
- (CHUD *)showHUDWithIdentifier:(NSString *)identifier text:(NSString *)text inView:(UIView *)view didDismissHandler:(ProgressHUDDidDismissHandler)didDismissHandler {
    [self clearDiscardHUD];
    
    CHUD *hud = [self createHUDWithIdentifier:identifier];
    hud.didDismissHandler = didDismissHandler;
    hud.textLabel.text = text;
    [hud showInView:view];
    return hud;
}


-(CHUD *)showToastWithMessage:(NSString *)message
                        inView:(UIView *)view
                         delay:(NSTimeInterval)delay
             didDismissHandler:(ProgressHUDDidDismissHandler)didDismissHandler{
    CHUD *hud = [self showHUDWithIdentifier:nil text:message inView:view didDismissHandler:didDismissHandler];
    [hud dismissAfterDelay:delay animated:YES];
    return hud;
}

-(CHUD *)showToastWithMessage:(NSString *)message didDismissHandler:(ProgressHUDDidDismissHandler)didDismissHandler{
    CHUD *hud =[self showToastWithMessage:message delay:ToastDelay didDismissHandler:didDismissHandler];
    return hud;
}

-(CHUD *)showToastWithMessage:(NSString *)message
                         delay:(NSTimeInterval)delay
             didDismissHandler:(ProgressHUDDidDismissHandler)didDismissHandler{
    CHUD *hud = [self showToastWithMessage:message
                                     inView:[self mainWindow]
                                      delay:delay
                          didDismissHandler:didDismissHandler];
    return hud;
}

-(CHUD *)showFailureHUDWithMessage:(NSString *)message
                         completion:(ProgressHUDDidDismissHandler)completionHandler{
    CHUD *hud = [self showFailureHUDWithMessage:message delay:ToastDelay completion:completionHandler];
    return hud;
}

-(CHUD *)showFailureHUDWithMessage:(NSString *)message
                              delay:(NSTimeInterval)delay
                         completion:(ProgressHUDDidDismissHandler)completionHandler{
    [self clearDiscardHUD];
    CHUD *hud = [self createHUDWithIdentifier:nil];
    hud.indicatorView = [[CPromptHUDIndicatorView alloc] init];
    hud.didDismissHandler = completionHandler;
    hud.textLabel.text = message;
    [hud showInView:[self mainWindow]];
    [hud dismissAfterDelay:delay animated:YES];
    return hud;
}


-(CHUD *)showSuccessHUDWithMessage:(NSString *)message
                         completion:(ProgressHUDDidDismissHandler)completionHandler{
    CHUD *hud = [self showSuccessHUDWithMessage:message delay:ToastDelay completion:completionHandler];
    return hud;
}

-(CHUD *)showSuccessHUDWithMessage:(NSString *)message
                              delay:(NSTimeInterval)delay
                         completion:(ProgressHUDDidDismissHandler)completionHandler{
    [self clearDiscardHUD];
    CHUD *hud = [self createHUDWithIdentifier:nil];
    hud.indicatorView = [[CSuccessHUDIndicatorView alloc] init];
    hud.didDismissHandler = completionHandler;
    hud.textLabel.text = message;
    [hud showInView:[self mainWindow]];
    [hud dismissAfterDelay:delay animated:YES];
    return hud;
}

#pragma mark - Loading

- (CHUD *)showLoadingHUDWithIdentifier:(NSString *)identifier text:(NSString *)text inView:(UIView *)view {
    CHUD *hud = [self showLoadingHUDWithIdentifier:identifier text:text inView:view didDismissHandler:nil];
    return hud;
}

- (CHUD *)showLoadingHUDWithIdentifier:(NSString *)identifier text:(NSString *)text inView:(UIView *)view didDismissHandler:(ProgressHUDDidDismissHandler)didDismissHandler {
    
    [self clearDiscardHUD];
    
    CHUD *hud = [self createHUDWithIdentifier:identifier];
    
    hud.indicatorView = [[CLoadingHUDIndicatorView alloc] init];
    
    if (!text || 0 == text.length) {
        hud.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    } else {
        hud.contentInsets = UIEdgeInsetsMake(16, 30, 16, 30);
    }
    
    hud.didDismissHandler = didDismissHandler;
    hud.textLabel.text = text;
    [hud showInView:view animated:NO];
    return hud;
}

#pragma mark -JGProgressHUDDelegate
- (void)progressHUD:(JGProgressHUD *)progressHUD willPresentInView:(UIView *)view {
    CHUD *hud = (CHUD *)progressHUD;
    if (hud.willPresentHandler) {
        hud.willPresentHandler(hud, view);
    }
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didPresentInView:(UIView *)view {
    CHUD *hud = (CHUD *)progressHUD;
    if (hud.didPresentHandler) {
        hud.didPresentHandler(hud, view);
    }
}

- (void)progressHUD:(JGProgressHUD *)progressHUD willDismissFromView:(UIView *)view {
    CHUD *hud = (CHUD *)progressHUD;
    if (hud.willDismissHandler) {
        hud.willDismissHandler(hud, view);
    }
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view {
    CHUD *hud = (CHUD *)progressHUD;
    if (hud.didDismissHandler) {
        hud.didDismissHandler(hud, view);
    }
    [self.huds removeObjectForKey:hud.identifier];
}

@end

