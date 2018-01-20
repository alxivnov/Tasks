//
//  EnterableCell.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 26.11.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "EnterableCell.h"

@implementation EnterableCell

@dynamic delegate;

- (void)doubleTap:(UITapGestureRecognizer *)sender {
	if (self.isEditing)
		return;
	
	self.selectedUnit = self.unit;

	if ([self.delegate respondsToSelector:@selector(didEnter:)])
		[self.delegate didEnter:self];
}

@end
