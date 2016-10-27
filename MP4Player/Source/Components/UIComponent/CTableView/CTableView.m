//
//  CTableView.m
//  CoolLibrary
//
//  Created by Chentao on 16/6/14.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CTableView.h"

@implementation CTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
@end
