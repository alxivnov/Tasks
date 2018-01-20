//
//  LoggerBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 06.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Basket+Process.h"
#import "Constants.h"
#import "LoggerBasket.h"
#import "NSArray+Query.h"
#import "SKInAppPurchase.h"
#import "Workflow.h"

@implementation LoggerBasket

- (void)clear:(NSArray *)indexPaths {
//	BOOL purchased = [SKInAppPurchase purchaseByIdentifier:[Constants inAppPurchaseLogger]].purchased;
	
	NSArray *cache = Nil;
	
//	if (purchased)
		cache = [indexPaths as:^id(id item) {
			return [self.basket index:[self rowForIndexPath:(NSIndexPath *)item]];
		}];
	
	[super clear:indexPaths];
	
//	if (purchased) {
		Basket *logger = [Workflow logger];
		
		if (self.basket.parent) {
			Action *parent = [self.basket.parent clone:NO];
			[parent.folderValues addRange:cache];
			
			[logger merge:parent at:0];
		} else {
			NSArray *reverse = [cache reverse];
			for (Action *item in reverse)
				[logger merge:item at:0];
		}
		
		for (Action *action in cache) {
			action.state = GTD_ACTION_STATE_NULL;
			action.loggerCount++;
			
			if (action.folder)
				for (Action *sub in action.folderValues.array) {
					sub.state = GTD_ACTION_STATE_NULL;
					sub.loggerCount++;
				}
		}
		
		[logger save];
//	}
}

@end
