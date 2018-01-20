//
//  FolderBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 07.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Process.h"
#import "Basket+Process.h"
#import "Constants.h"
#import "FolderBasket.h"
#import "SKInAppPurchase.h"
#import "UITableView+Rows.h"
#import "Workflow.h"

@implementation FolderBasket

- (void)done:(NSIndexPath *)indexPath {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	if (action.folder/* && [SKInAppPurchase purchaseByIdentifier:[Constants inAppPurchaseFolder]].purchased*/) {
		Action *first = [action.folderValues first];
		if (first.state != GTD_ACTION_STATE_DONE) {
			action.folderCount++;
			
			[[action.folderValues first] done];
			[action.folderValues sortRowAt:0];
			[self.basket save];
			
			[self.tableView reloadRowAtIndexPath:indexPath withAnimation:UITableViewRowAnimationAutomatic];
		
			return;
		}
	}
	
	self.basket.parent.folderCount++;
	
	[super done:indexPath];
}

- (void)undone:(NSIndexPath *)indexPath {
	self.basket.parent.folderCount--;
	
	[super undone:indexPath];
}

@end
