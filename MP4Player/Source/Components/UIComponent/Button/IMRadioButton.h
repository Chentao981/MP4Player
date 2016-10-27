//
//  IMRadioButton.h
//  IMRadioButtonUseing
//
//  Created by Chentao on 14/10/22.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "IMCheckBox.h"

@class IMRadioButton;
@interface IMRadioButtonGroup : NSObject

@property (nonatomic, strong) NSMutableArray *items;
/**
 *是否允许不选，yes允许，no不允许
 **/
@property (nonatomic, assign) BOOL uncheck;

@property (nonatomic, readonly) IMRadioButton *selectedRadioButton;

- (void)selecteItem:(IMCheckBox *)item;
- (void)addItem:(IMCheckBox *)item;
- (void)removeItem:(IMCheckBox *)item;
@end

@interface IMRadioButton : IMCheckBox
@property (nonatomic, strong) IMRadioButtonGroup *group;
@end
