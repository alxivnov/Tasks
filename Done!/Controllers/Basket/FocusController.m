//
//  FocusBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 09.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Period.h"
#import "AlertHelper.h"
#import "Basket+Period.h"
#import "Basket+Query.h"
#import "ColorScheme.h"
#import "Constants.h"
#import "CustomBasket+Hint.h"
#import "DateHelper.h"
#import "FocusController.h"
#import "Images.h"
#import "Localization.h"
#import "Sounds.h"

#import "NSHelper.h"
#import "NSObject+Cast.h"
#import "NSString+Calculation.h"
#import "UIAlertController+Compatibility.h"
#import "UIAlertViewEx.h"
#import "UIHelper.h"
#import "UIView+Position.h"
#import "UIView+Snapshot.h"
#import "UIViewController+Hierarchy.h"
#import "UIViewController+Transition.h"

@interface FocusController ()
@property (assign, nonatomic) NSInteger period;

@property (assign, nonatomic) NSRange range;
@end

@implementation FocusController

+ (Basket *)getValues:(UIViewController *)controller {
	FocusController *vc = [FocusController viewController:controller];
	return vc.basket;
}

+ (void)setValues:(Basket *)basket forViewController:(UIViewController *)controller {
	FocusController *vc = [FocusController viewController:controller];
	vc.basket = basket;
	
	vc.period = DATE_TODAY;
	[vc didUpdateModel];
	
	[vc moveCenter];
}
/*
- (CGFloat)topInset {
	return STATUS_BAR_HEIGHT;
}
*/
- (NSUInteger)rowForIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row + self.range.location;
}

- (NSIndexPath *)indexPathForRow:(NSUInteger)row {
	return (NSLocationInRange(row, self.range))
		? [NSIndexPath indexPathForRow:row - self.range.location inSection:0]
		: Nil;
}

- (BOOL)didUpdateModel {
	NSRange range = [self.basket rangeWherePeriodIsEqualTo:self.period];
	if (NSEqualRanges(range, self.range))
		return NO;
	
	self.range = range;
	return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.range.length;
}

- (void)tap:(UITapGestureRecognizer *)sender {
	if (self.table.isUnfocused)
		return;
	
	[super tap:sender];
}

- (void)dismiss:(id <UIPinchTransitionDelegate>)delegate {
	if ([self.presentingViewController isKindOfClass:[UITableViewController class]])
		[((UITableViewController *)self.presentingViewController).tableView reloadData];
	
	[super dismiss:delegate];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([self.tableView visibleCells].count > 0)
		return;
	
	[self hint:[Localization emptyFocus]];
}

// BasketControllerDelegate

- (BOOL)didReceiveNotification:(NSString *)uuid withAction:(NSString *)identifier {
	NSUInteger index = [self.basket indexWhereUuidIsEqualTo:uuid];
	
	return NSLocationInRange(index, self.range) ? [super didReceiveNotification:uuid withAction:identifier] : NO;
}
/*
- (void)significantTimeChange {
	[self didUpdateModel];
	
	[super significantTimeChange];
}

- (void)didChangeExternally {
	[self didUpdateModel];
	
	[super didChangeExternally];
}
*/
- (void)reloadTableView:(BOOL)force {
	[self didUpdateModel];
	
	[super reloadTableView:force];
}

// ScrollableBasket

- (void)animate:(UIPosition)position {
	UIView *snapshot = [self.tableView snapshotView];
	[self.view addSubview:snapshot];
	[UIHelper curveEaseInWithDuration:DURATION_XS animations:^{
		snapshot.alpha = 0.0;
		[snapshot dock:position];
	} completion:^(BOOL finished) {
		[snapshot removeFromSuperview];
	}];
}

- (BOOL)moveUp {
	if (self.range.location <= 0)
		return NO;
	
	[self animate:UIPositionBottom];
	
	self.period = [[self.basket index:self.range.location - 1] period];
	
	[self reloadTableView:YES];
	
	return YES;
}

- (BOOL)moveDown {
	NSUInteger count = self.range.location + self.range.length;
	
	if (count >= self.basket.count)
		return NO;
	
	[self animate:UIPositionTop];
		
	self.period = [[self.basket index:count] period];
	
	[self reloadTableView:YES];
	
	return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[super scrollViewDidScroll:scrollView];
}

- (void)addWithState:(ScrollState)state {
	if ([self moveUp])
		[Sounds navigation];
	else {
		if (self.period != PERIOD_IN_BASKET) {
			self.period = PERIOD_IN_BASKET;

			[self reloadTableView:YES];
		}
		
		[super addWithState:state];
	}
}

- (void)clearWithState:(ScrollState)state {
	if ([self moveDown])
		[Sounds navigation];
	else {
		[super clearWithState:state];
		
		[self moveCenter];
	}
}

- (void)showStatistics:(BOOL)show withState:(ScrollState)state {
	[super showStatistics:YES withState:0];
}

- (void)setImageForState:(ScrollState)state {
	NSUInteger count = self.range.location + self.range.length;
	
	if (state < ScrollZero && count < self.basket.count) {
		Action *action = [self.basket index:count];
		[self.statisticsView setDetail:[action periodDescription]];
		
		if (state == ScrollUpS)
			[self.statisticsView setImage:[Images downLine] andColor:[ColorScheme instance].lightGrayColorEx];
		else
			[self.statisticsView setImage:[Images downFull] andColor:[ColorScheme instance].lightGrayColor];
	} else if (state > ScrollZero && self.range.location > 0) {
		Action *action = [self.basket index:self.range.location - 1];
		[self.statisticsView setDetail:[action periodDescription]];
		
		if (state == ScrollDownS)
			[self.statisticsView setImage:[Images upLine] andColor:[ColorScheme instance].lightGrayColorEx];
		else
			[self.statisticsView setImage:[Images upFull] andColor:[ColorScheme instance].lightGrayColor];
	} else {
		[self.statisticsView setDetail:Nil];
		
		[super setImageForState:state];
	}
}

- (void)playSoundForState:(ScrollState)state {
	if (self.state != ScrollDownL && self.state != ScrollUpL && state != ScrollDownL && state != ScrollUpL)
		[super playSoundForState:state];
}

- (void)didEndEditing:(EditableCell *)sender {
	[super didEndEditing:sender];
	
	if (!sender.title.text.length || [sender.title.text isWhitespace])
		[self moveCenter];
}

- (void)action:(NSInteger)buttonIndex with:(NSIndexPath *)indexPath {
	[super action:buttonIndex with:indexPath];
	
	if (buttonIndex != ALERT_CANCEL)
		[self moveCenter];
}

- (BOOL)process:(PannableCell *)sender {
	BOOL modal = [super process:sender];
	
	if (!modal)
		[self moveCenter];
	
	return modal;
}

- (void)doneProcess:(UIViewController *)viewController {
	[super doneProcess:viewController];
	
	[self moveCenter];
}

- (void)moveCenter {
	if (self.range.length > 0)
		return;
	
	NSUInteger index = [self.basket indexWherePeriodIsCloseTo:self.period];
	if (index == NSNotFound)
		[self dismiss:Nil];
	else {
		[self animate:index < self.range.location ? UIPositionBottom : UIPositionTop];
		
		self.period = [[self.basket index:index] period];
		
		[self reloadTableView:YES];
	}
}

@end
