//
//  InBasketController.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "InBasketController.h"
#import "AlertHelper.h"
#import "Action+Send.h"
#import "Basket+Query.h"
#import "CloudStatistics+Help.h"
#import "Constants.h"
#import "CustomCell+Blink.h"
#import "FocusController.h"
#import "FolderController.h"
#import "Localization.h"
#import "LocalizationPurchase.h"
#import "NotificationHelper.h"
#import "SocialHelper.h"
#import "Sounds.h"
#import "Workflow.h"

#import "CSSearchableIndex+Convenience.h"
#import "NSArray+Random.h"
#import "NSHelper.h"
#import "NSObject+Cast.h"
#import "NSString+Alert.h"
#import "NSURL+HTML.h"
#import "NSURL+Parse.h"
#import "UIColorCache.h"
#import "UILocalNotification+Convenience.h"
#import "UIPinchGestureRecognizer+Scale.h"
#import "UIRateCell.h"
#import "UIRateController.h"
#import "UIViewController+Alert.h"
#import "UIViewController+Transition.h"

@interface InBasketController ()
@property (strong, nonatomic, readonly) UIRateCell *rateCell;
@end

@implementation InBasketController

@synthesize rateCell = _rateCell;

- (UIRateCell *)rateCell {
	if (!_rateCell && IOS_8_0) {
		RATE_CONTROLLER.view.tintColor = [@[ [RGB_CACHE ncsBlue], [RGB_CACHE ncsGreen], [RGB_CACHE ncsOrange], [RGB_CACHE ncsRed], [RGB_CACHE ncsViolet], [RGB_CACHE ncsYellow] ] randomItem];
		
		_rateCell = [UIRateCell create:RATE_CONTROLLER];
	}
	
	return _rateCell;
}

// AppDelegate

- (BOOL)didReceiveNotification:(NSString *)uuid withAction:(NSString *)identifier {
	if ([self.presentedViewController isKindOfClass:[FocusController class]] && [(FocusController *)self.presentedViewController didReceiveNotification:uuid withAction:identifier])
		return YES;
	
	return [super didReceiveNotification:uuid withAction:identifier];
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification withAction:(NSString *)identifier {
	if (!notification)
		return;
	
	NSString *uuid = notification.identifier;
	
	[AlertHelper didReceiveLocalNotificationWithUUID:uuid];
	
	[self didReceiveNotification:uuid withAction:identifier];
}

- (void)openFile:(NSURL *)url {
	[Workflow instance].statistics.openURL++;

	url = [url importHTML];
	
	if ([[url scheme] isEqualToString:URL_SCHEME] && ![url.host isEqualToString:@"share"]) {
		NSDictionary *dictionary = [url queryDictionary];
		
		NSString *uuid = dictionary[URL_PARAMETER_UUID];
		
		[self didReceiveNotification:uuid withAction:GUI_NOTIFICATION_ACTION_QUESTION];
	} else {
		Action *action = [url.host isEqualToString:@"share"] ? [Action importFromDictionary:[url queryDictionary]] : [Action importFromFile:url];
		
		[[NSFileManager defaultManager] removeItemAtURL:url error:Nil];
		
		if (!action.uuid)
			return;
		
		[self import:action];
		
		[self didReceiveNotification:action.uuid withAction:GUI_IMPORT];
	}
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
	NSString *uuid = userActivity.userInfo[[userActivity.activityType isEqualToString:CSSearchableItemActionType] ? CSSearchableItemActivityIdentifier : STR_TASK];
	return uuid.length ? [self didReceiveNotification:uuid withAction:GUI_NOTIFICATION_ACTION_QUESTION] : NO;
}

- (void)significantTimeChange {
	if ([self.presentedViewController isKindOfClass:[FocusController class]])
		[(FocusController *)self.presentedViewController significantTimeChange];
	else
		[super significantTimeChange];
}

- (void)didBecomeActive {
	if ([self.presentedViewController isKindOfClass:[FocusController class]])
		[(FocusController *)self.presentedViewController didBecomeActive];
	else
		[super didBecomeActive];
}

// SKReceiptObserverDelegate

- (void)didUpdateReceipt:(BOOL)valid {
	if ([self.presentedViewController isKindOfClass:[FocusController class]])
		[(FocusController *)self.presentedViewController didUpdateReceipt:valid];
	else
		[super didUpdateReceipt:valid];
}

- (void)didRestorePurchases {
	[self presentAlertWithTitle:[LocalizationPurchase restored] cancelButtonTitle:[Localization ok]];
}

- (void)didFailWithError:(NSError *)error sender:(id)sender {
	[self presentAlertWithError:error cancelButtonTitle:[Localization cancel]];
}

// BasketDelegate

- (void)willChangeExternally:(NSNotification *)notification {
	PERFORM_SELECTOR(self.presentedViewController, @selector(willReloadTableView));
	else
		[super willReloadTableView];
}

- (void)didChangeExternally:(NSNotification *)notification {
	PERFORM_SELECTOR(self.presentedViewController, @selector(didChangeExternally));
	else
		[super didChangeExternally];
}

// Settings

- (void)migrate {
	[self reloadTableView:YES];
}



- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (self.count > 1)
		return;
	
	[Workflow instance].statistics.launch++;
	
	if (self.settings.sounds)
		[Sounds on];
	else
		[Sounds off];
	
	[SocialHelper setupDefaultURLs];
	
	RATE_CONTROLLER.appIdentifier = APP_ID_DONE;
	RATE_CONTROLLER.recipient = EMAIL;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.count > 1)
		return;
	
	NSTimeInterval time = [Constants dateTime];
	if (!time)
		return;
	
	[self presentAlertWithTitle:[@(fabs(time)) description] cancelButtonTitle:[Localization ok]];
}

- (FocusController *)instantiateFocusController {
	FocusController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:GUI_FOCUS];
	
	[FocusController setValues:self.basket forViewController:vc];
	
	return vc;
}

- (void)pinch:(UIPinchGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan) {
		if ([sender pinchIn])
			[self presentViewControllerWithIdentifier:GUI_SETTINGS withTransition:[UIPinchTransition interactivePinchIn:self]];
		else if ([sender pinchOut])
			[self presentViewController:[self instantiateFocusController] withTransition:[UIPinchTransition interactivePinchOut:self]];
	}
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		if (self.popover || self.actionSheet || [self.presentedViewController isKindOfClass:[UIAlertController class]] || [self.presentedViewController isKindOfClass:[UIActivityViewController class]])
			[super motionEnded:motion withEvent:event];
		else if (self.table.isUnfocused) {
			[self presentViewController:[self instantiateFocusController] fromView:Nil];
			
			[Sounds navigation];
		}
	}
}

- (void)showStatistics:(BOOL)show withState:(ScrollState)state {
	[super showStatistics:show withState:(state > ScrollZero && [self.statistics hintTop]) || (state < ScrollZero && [self.statistics hintBottom:NO]) ? state : 0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return (RATE_CONTROLLER.view && self.rateCell ? 1 : 0) + [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return RATE_CONTROLLER.view && self.rateCell && !section ? 1 : [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return RATE_CONTROLLER.view && self.rateCell && !indexPath.section ? self.rateCell : [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForRow:(NSUInteger)row {
	return [NSIndexPath indexPathForRow:row inSection:RATE_CONTROLLER.view && self.rateCell ? 1 : 0];
}

- (NSUInteger)rowForIndexPath:(NSIndexPath *)indexPath {
	return RATE_CONTROLLER.view && self.rateCell && !indexPath.section ? NSNotFound : indexPath.row;
}

@end
