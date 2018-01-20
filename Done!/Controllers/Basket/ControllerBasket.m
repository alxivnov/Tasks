//
//  ControllerBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 08.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ControllerBasket.h"
#import "Basket+Query.h"
#import "EditableCell.h"
#import "Localization.h"
#import "Sounds.h"

#import "NSArray+Query.h"
#import "NSObject+Cast.h"

@implementation ControllerBasket

- (void)tap:(UITapGestureRecognizer *)sender {
	if (self.table.isUnfocused)
		if (![self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]])
			[self add];
}

- (void)add {
	if (self.repeatAdd)
		self.statistics.repeatingAdd++;
	else
		self.statistics.beginAdd++;
	[Sounds add];
	
	NSIndexPath *indexPath = /*[self indexPathForRow:0];	// */[NSIndexPath indexPathForRow:0 inSection:0];
	[self add:indexPath];
	
	EditableCell *cell = [(UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] as:[EditableCell class]];
	[cell beginEditing:[Localization newAction]];
}

- (void)clear {
	NSArray *indexes = [self.basket indexesWhereStateIsEqualToDone];
	if ([indexes count] == 0)
		return;
	
	self.statistics.clear++;
	[Sounds clear];
	
	[self clear:[indexes as:^id(id item) {
		NSIndexPath *indexPath = [self indexPathForRow:[((NSNumber *)item) integerValue]];
		return indexPath;
	}]];
	
	[self updateTourPrompt];
}

@end
