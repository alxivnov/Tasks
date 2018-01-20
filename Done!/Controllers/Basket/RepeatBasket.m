//
//  RepeatBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 16.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Repeat.h"
#import "Constants.h"
#import "RepeatBasket.h"
#import "SKInAppPurchase.h"
#import "UITableView+Rows.h"

@implementation RepeatBasket

- (void)done:(NSIndexPath *)indexPath {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	if (action.repeat/* && [SKInAppPurchase purchaseByIdentifier:[Constants inAppPurchaseRepeat]].purchased*/) {
		action.repeatCount++;
		
		if (action.state == GTD_ACTION_STATE_CALENDAR)
			[super calendar:indexPath date:[action repeatDate] repeat:Nil sound:Nil alert:Nil];
		else
			[super deferral:indexPath date:[action repeatDate]];
		
		return;
	}
	
	[super done:indexPath];
}

- (void)skip:(NSIndexPath *)indexPath {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	if (action.repeat/* && [SKInAppPurchase purchaseByIdentifier:[Constants inAppPurchaseRepeat]].purchased*/) {
		if (action.state == GTD_ACTION_STATE_CALENDAR)
			[super calendar:indexPath date:[action repeatDate] repeat:Nil sound:Nil alert:Nil];
		else
			[super deferral:indexPath date:[action repeatDate]];
	}
}

- (void)repeat:(NSIndexPath *)indexPath values:(NSArray *)values {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	action.repeatValues = values;
	
	if (action.state == 0) {
		[self deferral:indexPath date:[action repeatDate]];
	} else {
		[self.tableView reloadRowAtIndexPath:indexPath withAnimation:UITableViewRowAnimationAutomatic];
		
		[self.basket save];
	}
}

@end
