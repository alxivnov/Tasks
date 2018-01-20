//
//  BasketController.m
//  Done!
//
//  Created by Alexander Ivanov on 03.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Folder.h"
#import "Action+Repeat.h"
#import "ActionCell.h"
#import "AlertHelper.h"
#import "Basket+Query.h"
#import "BasketController.h"
#import "Constants.h"
#import "CustomCell+Blink.h"
#import "DateHelper.h"
#import "Localization.h"
#import "LocalizationAlert.h"
#import "LocalizationPurchase.h"
#import "NotificationHelper.h"
#import "NSArray+Query.h"
#import "NSDate+Calculation.h"
#import "NSDate+Description.h"
#import "NSHelper.h"
#import "NSObject+Cast.h"
#import "UIAlertController+Compatibility.h"
#import "UIAlertViewEx.h"
#import "UIHelper.h"
#import "UITableView+Rows.h"
#import "UIViewController+Alert.h"

@interface BasketController()
@property (strong, nonatomic) NSIndexPath *basketIndexPath;

@property (strong, nonatomic) NSArray *deferralDates;
@property (strong, nonatomic) NSArray *deferralTimes;
@end

@implementation BasketController

+ (NSArray *)deferralTimes:(NSDate *)date {
	NSDate *d00 = [NSDate date];
	if ([d00 isLessThan:date])
		d00 = date;
	NSDate *d10 = [[d00 move:10 * TIME_MINUTE] round:TIME_MINUTE];
	NSDate *d30 = [[d00 move:30 * TIME_MINUTE] round:TIME_MINUTE];
	NSDate *d60 = [[d00 move:60 * TIME_MINUTE] round:TIME_MINUTE];
	
	return @[ d00, [d00 descriptionForTime:NSDateFormatterShortStyle],
			  d10, [d10 descriptionForTime:NSDateFormatterShortStyle],
			  d30, [d30 descriptionForTime:NSDateFormatterShortStyle],
			  d60, [d60 descriptionForTime:NSDateFormatterShortStyle],
			  ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.basket count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ActionCell *cell = [[super tableView:tableView cellForRowAtIndexPath:indexPath] as:[ActionCell class]];
	cell.delegate = self;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	[cell setup:action];
    
    return cell;
}

- (void)blink:(NSArray *)indexPaths {
	[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];

	for (CustomCell *cell in [indexPaths as:^id(id item) {
		return [self.tableView cellForRowAtIndexPath:item];
	}])
		[cell blink:DURATION_M];
}

- (void)postpone:(NSUInteger)index with:(NSIndexPath *)indexPath {
	if (index == ALERT_CANCEL || index == ALERT_DO)
		[self action:index with:indexPath];
	else if (self.deferralDates)
		[self deferral:indexPath date:index * 2 < self.deferralDates.count ? self.deferralDates[index * 2] : Nil];
	else if (self.deferralTimes)
		[self calendar:indexPath date:self.deferralTimes[index * 2] repeat:Nil sound:Nil alert:Nil];
	
	self.deferralDates = Nil;
	self.deferralTimes = Nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	NSInteger index = buttonIndex == alertView.cancelButtonIndex ? ALERT_CANCEL
		: [buttonTitle isEqualToString:[LocalizationAlert actionComplete]] ? ALERT_DO
		: buttonIndex - 1;
	
	if (self.deferralDates || self.deferralTimes)
		[self postpone:index with:self.basketIndexPath];
//	else
//		[self action:index with:self.basketIndexPath];
}

- (BOOL)didReceiveNotification:(NSRange)range {
	if (!range.length)
		return NO;
	
	NSArray *array = [NSArray arrayFromRange:range using:^id(NSUInteger index) {
		return [self indexPathForRow:index];
	}];
	
	if (!array.count)
		return NO;
		
	if (self.table.isUnfocused)
		[self.tableView scrollToRowAtIndexPath:[array firstObject] atScrollPosition:UITableViewScrollPositionTop animated:YES];
			
	[self performSelector:@selector(blink:) withObject:array afterDelay:DURATION_M];
			
	return YES;
}

- (BOOL)didReceiveNotification:(NSString *)uuid withAction:(NSString *)identifier {
	[self dismissAll:NO];
	
	if ([uuid isEqualToString:ALERT_OVERDUE])
		return [self didReceiveNotification:[self.basket rangeWhereDateIsLessThan:[AlertHelper today]]];
	else if ([uuid isEqualToString:ALERT_PROCESS])
		return [self didReceiveNotification:[self.basket rangeWhereStateIsEqualToZero]];
	
	NSUInteger index = [self.basket indexWhereUuidIsEqualTo:uuid];
	if (index == NSNotFound)
		return NO;
	
	self.basketIndexPath = [self indexPathForRow:index];
	
	if ([identifier isEqualToString:GUI_NOTIFICATION_ACTION_COMPLETE]) {
		[self done:self.basketIndexPath];
		
		[self.statistics incrementDone];
	} else if ([identifier isEqualToString:GUI_NOTIFICATION_ACTION_POSTPONE]) {
		[self calendar:self.basketIndexPath date:[[[NSDate date] move:self.settings.postponeTime] round:TIME_MINUTE] repeat:Nil sound:Nil alert:Nil];
	} else {
		if (self.table.isUnfocused)
			[self.tableView scrollToRowAtIndexPath:self.basketIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
		[self performSelector:@selector(blink:) withObject:ARRAY(self.basketIndexPath) afterDelay:DURATION_L];
		
		if (![identifier isEqualToString:GUI_IMPORT]) {
			Action *action = [self.basket index:[self rowForIndexPath:self.basketIndexPath]];
			if (action) {
				NSString *title = [action folderDescription];
				NSString *message = [NSString stringWithFormat:@"\n%@", [action repeatDateDescription]];
				
				if (action.state == GTD_ACTION_STATE_CALENDAR) {
					self.deferralTimes = [[self class] deferralTimes:action.date];
					
					__weak BasketController *__self = self;
					[self presentAlertWithTitle:title message:message cancelButtonTitle:[Localization cancel] destructiveButtonTitle:Nil otherButtonTitles:@[ [LocalizationAlert actionComplete], self.deferralTimes[3], self.deferralTimes[5], self.deferralTimes[7] ] completion:^(UIAlertController *instance, NSInteger index) {
						[__self postpone:index < 0 || index == ALERT_CANCEL || index == ALERT_DESTRUCTIVE ? index : index == 0 ? ALERT_DO : index with:__self.basketIndexPath];
					}];
				} else if (action.state == GTD_ACTION_STATE_DEFERRAL) {
					self.deferralDates = [DateHelper deferralDates];
					
					__weak BasketController *__self = self;
					[self presentAlertWithTitle:title message:message cancelButtonTitle:[Localization cancel] destructiveButtonTitle:Nil otherButtonTitles:@[ [LocalizationAlert actionComplete], self.deferralDates[3], self.deferralDates[5], self.deferralDates[7], self.deferralDates[9], [Localization someday] ] completion:^(UIAlertController *instance, NSInteger index) {
						[__self postpone:index < 0 || index == ALERT_CANCEL || index == ALERT_DESTRUCTIVE ? index : index == 0 ? ALERT_DO : index with:__self.basketIndexPath];
					}];
				}
			}
		}
	}
	
	return YES;
}

- (void)didBecomeActive {
	if (![self updateColorScheme])
		[self reloadTableView:NO];
}

- (void)didUpdateReceipt:(BOOL)valid {
	if (valid)
		[self reloadTableView:YES];
	else
		[self presentAlertWithTitle:[LocalizationPurchase expired] cancelButtonTitle:[Localization cancel]];
}

- (void)didPassPurchase:(NSString *)identifier {
	[self reloadTableView:YES];
	
	if ([identifier isEqualToString:[Constants inAppPurchaseRepeat]])
		self.statistics.purchaseRepeat++;
	else if ([identifier isEqualToString:[Constants inAppPurchaseFolder]])
		self.statistics.purchaseFolder++;
	else if ([identifier isEqualToString:[Constants inAppPurchaseLogger]])
		self.statistics.purchaseLogger++;
}

- (void)didChangeExternally {
	[self dismissAll:NO];
	
	[self reloadTableView:YES];
}

@end
