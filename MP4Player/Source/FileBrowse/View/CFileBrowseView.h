//
//  CFileBrowseView.h
//  MP4Player
//
//  Created by Chentao on 2016/10/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "Group.h"
#import "CTableView.h"

#pragma mark-Event
#define FileBrowseView_BackButton_Touch @"FileBrowseView_BackButton_Touch"

@interface CFileBrowseView : Group

@property(nonatomic,strong)CTableView *fileListView;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,assign)BOOL showBackButton;


@end
