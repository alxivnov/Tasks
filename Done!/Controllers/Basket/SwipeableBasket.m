//
//  SwipeableBasket.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 02.01.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "SwipeableBasket.h"
#import "Constants.h"

#import "NSHelper.h"
#import "NSIndexPath+Equality.h"
#import "NSObject+Cast.h"
#import "UIAlertController+Compatibility.h"
#import "UIAlertViewEx.h"
#import "UIHelper.h"
#import "UITableViewWithFocus.h"

@interface SwipeableBasket ()
@property (strong, nonatomic) NSIndexPath *swipeIndexPath;
@end

@implementation SwipeableBasket

- (void)beginSwiping:(UITableViewCell *)sender {
	if (self.swipeIndexPath)
		return;
	
	self.swipeIndexPath = [self.tableView indexPathForCell:sender];
	
	self.tableView.scrollEnabled = NO;
	
	[self.table focusOnCells:ARRAY(sender) withDuration:0];
}

- (void)endSwiping:(NSTimeInterval)duration {
	if (!self.swipeIndexPath)
		return;
	
	self.swipeIndexPath = Nil;
	
	self.tableView.scrollEnabled = YES;
	
	[self.table defocusWithDuration:duration];
}

- (void)tap:(UITapGestureRecognizer *)sender {
	if (self.swipeIndexPath) {
		if (![self.swipeIndexPath isEqualToIndexPath:[self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]]])
			[self dismissSwipe];
	} else {
		[super tap:sender];
	}
}

- (void)willBeginSwiping:(SwipeableCell *)sender {
	[self beginSwiping:sender];
}

- (void)willEndSwiping:(SwipeableCell *)sender {
	[self endSwiping:0];
}

- (void)action:(NSInteger)buttonIndex with:(NSIndexPath *)indexPath {
	[super action:buttonIndex with:indexPath];
	
	if (buttonIndex != ALERT_CANCEL)
		[self endSwiping:DURATION_XXS];
}

- (BOOL)process:(PannableCell *)sender {
	BOOL modal = [super process:sender];
	
	if (!modal)
		[self endSwiping:DURATION_XXS];
	
	return modal;
}

- (void)doneProcess:(UIViewController *)viewController {
	[super doneProcess:viewController];
	
	[self endSwiping:DURATION_XXS];
}

- (void)dismissSwipe {
	if (self.swipeIndexPath) {
		SwipeableCell *cell = [[self.tableView cellForRowAtIndexPath:self.swipeIndexPath] as:[SwipeableCell class]];
		[cell endSwipe];
	}
}

@end
