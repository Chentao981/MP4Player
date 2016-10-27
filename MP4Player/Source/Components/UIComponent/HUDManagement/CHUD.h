//
//  CHUD.h
//  MP4Player
//
//  Created by Chentao on 2016/10/27.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import <JGProgressHUD/JGProgressHUD.h>





@class CHUD;

typedef void (^ProgressHUDWillPresentHandler)(CHUD *_Nullable hud, UIView *_Nullable inView);

typedef void (^ProgressHUDDidPresentHandler)(CHUD *_Nullable hud, UIView *_Nullable inView);

typedef void (^ProgressHUDWillDismissHandler)(CHUD *_Nullable hud, UIView *_Nullable inView);

typedef void (^ProgressHUDDidDismissHandler)(CHUD *_Nullable hud, UIView *_Nullable inView);

@interface CHUD : JGProgressHUD

@property (nonatomic, copy,nullable) ProgressHUDWillPresentHandler willPresentHandler;

@property (nonatomic, copy,nullable) ProgressHUDDidPresentHandler didPresentHandler;

@property (nonatomic, copy,nullable) ProgressHUDWillDismissHandler willDismissHandler;

@property (nonatomic, copy,nullable) ProgressHUDDidDismissHandler didDismissHandler;

@property(nonatomic,copy,nonnull)NSString *identifier;


@end
