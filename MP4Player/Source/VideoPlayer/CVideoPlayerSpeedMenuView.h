//
//  CVideoPlayerSpeedMenuView.h
//  CVideoPlayer
//
//  Created by Chentao on 16/8/9.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "VBox.h"

#pragma mark-Event

#define CVideoPlayerSpeedMenuItem_Selected_Change @"CVideoPlayerSpeedMenuItem_Selected_Change"

#define CVideoPlayerSpeedMenuView_DidSelected @"CVideoPlayerSpeedMenuView_DidSelected"


@interface CVideoPlayerSpeedMenuItem : NSObject

@property(nonatomic,assign)float speed;
@property(nonatomic,assign)BOOL selected;

@end

@interface CVideoPlayerSpeedMenuItemView : UIButton

@property(nonatomic,strong)CVideoPlayerSpeedMenuItem *menuItem;

@property(nonatomic,assign)BOOL showBottomLine;

@end


@interface CVideoPlayerSpeedMenuView : VBox

@property(nonatomic,readonly,assign)BOOL show;

@property(nonatomic,strong)NSArray<CVideoPlayerSpeedMenuItem *> *speedArray;

-(void)showMenuView;

-(void)hidenMenuView;

@end
