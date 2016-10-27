//
//  IMRadioButton.m
//  IMRadioButtonUseing
//
//  Created by Chentao on 14/10/22.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "IMRadioButton.h"

@implementation IMRadioButtonGroup

- (void)addItem:(IMCheckBox *)item {
	if (!self.items) {
		self.items = [[NSMutableArray alloc]init];
	}
	[self.items addObject:item];
}

- (void)removeItem:(IMCheckBox *)item {
	[self.items removeObject:item];
}

- (void)selecteItem:(IMCheckBox *)item {
	for (IMCheckBox *tempItem in self.items) {
		if (tempItem != item) {
			tempItem.selected = NO;
		}
	}
}

- (IMRadioButton *)selectedRadioButton {
	for (IMRadioButton *tempItem in self.items) {
		if (tempItem.selected) {
			return tempItem;
		}
	}
	return nil;
}

@end

@implementation IMRadioButton

- (void)touchHandler {
	if (_group) {
		if (_group.uncheck) {
			self.selected = !self.selected;
		}
		else {
			if (!self.selected) {
				self.selected = YES;
			}
		}
	}
	else {
		self.selected = !self.selected;
	}

	if (self.delegate && [self.delegate respondsToSelector:@selector(checkBoxOnTouch:)]) {
		[self.delegate checkBoxOnTouch:self];
	}
}

- (void)setGroup:(IMRadioButtonGroup *)group {
	if (_group != group) {
		if (_group) {
			[_group removeItem:self];
		}
		_group = group;
		if (_group) {
			[_group addItem:self];
		}
	}
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (self.selected) {
		if (_group) {
			[_group selecteItem:self];
		}
	}
}

@end
