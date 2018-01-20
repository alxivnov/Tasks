//
//  SettingsController.m
//  Done!
//
//  Created by Alexander Ivanov on 07.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>

#import "SettingsController.h"
#import "AlertHelper.h"
#import "Basket+Alert.h"
#import "ColorScheme.h"
#import "Constants.h"
#import "DatePickerController.h"
#import "HelpHelper.h"
#import "InBasketController.h"
#import "Localization.h"
#import "LocalizationHelp.h"
#import "LocalizationSettings.h"
#import "Notification+Description.h"
#import "SocialHelper.h"
#import "Sounds.h"
#import "Workflow.h"

#import "NSBundle+Convenience.h"
#import "NSDate+Calculation.h"
#import "NSDate+Description.h"
#import "NSHelper.h"
#import "NSObject+Cast.h"
#import "UIPinchGestureRecognizer+Scale.h"
#import "UIView+Gestures.h"
#import "UIViewController+Hierarchy.h"
#import "UIViewController+Product.h"
#import "UIViewController+Transition.h"

@interface SettingsController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;

@property (weak, nonatomic) IBOutlet UISwitch *iCloudSwitch;

@property (weak, nonatomic) IBOutlet UILabel *soundsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *soundsSwitch;

@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *multilineTilesLabel;
@property (weak, nonatomic) IBOutlet UISwitch *multilineTilesSwitch;

@property (weak, nonatomic) IBOutlet UILabel *deleteConfirmationLabel;
@property (weak, nonatomic) IBOutlet UISwitch *deleteConfirmationSwitch;

@property (weak, nonatomic) IBOutlet UILabel *iconBadgeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *iconBadgeSwitch;

@property (weak, nonatomic) IBOutlet UILabel *calendarReminderLabel;
@property (weak, nonatomic) IBOutlet UILabel *calendarReminderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueReminderLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueReminderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *processReminderLabel;
@property (weak, nonatomic) IBOutlet UILabel *processReminderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewReminderLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewReminderTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *postponeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postponeTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *restorePurchasesLabel;

@property (strong, nonatomic) Basket *basket;
@property (strong, nonatomic) Settings *settings;
@property (strong, nonatomic) Statistics *statistics;

@property (strong, nonatomic) UIPinchGestureRecognizer *pinch;

@property (strong, nonatomic) NSString *segueIdentifier;

@end

@implementation SettingsController

- (CGFloat)topInset {
	return 0;
}

- (Basket *)basket {
	return [Workflow instance].basket;
}

- (Settings *)settings {
	return [Workflow instance].settings;
}

- (Statistics *)statistics {
	return [Workflow instance].statistics;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	return [gestureRecognizer numberOfTouches] <= 2;
}

- (void)pinch:(UIPinchGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan && [sender pinchOut])
		[self dismiss:self];
}

- (UIPinchGestureRecognizer *)pinch {
	if (!_pinch)
		_pinch = [self.view addPinch:self];
	
	return _pinch;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.pinch.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.statistics.settings++;
	
	self.nameLabel.text = [NSBundle bundleDisplayName];
	self.versionLabel.text = [NSBundle bundleShortVersionString];
	self.helpLabel.text = [LocalizationHelp help];
	self.feedbackLabel.text = [LocalizationSettings feedback];
	self.soundsLabel.text = [LocalizationSettings sounds];
	self.themeLabel.text = [LocalizationSettings theme];
	self.multilineTilesLabel.text = [LocalizationSettings multilineTitles];
	self.deleteConfirmationLabel.text = [LocalizationSettings deleteConfirmation];
	self.iconBadgeLabel.text = [LocalizationSettings iconBadge];
	self.calendarReminderLabel.text = [LocalizationSettings calendarReminder];
	self.overdueReminderLabel.text = [LocalizationSettings overdueReminder];
	self.processReminderLabel.text = [LocalizationSettings processReminder];
	self.reviewReminderLabel.text = [LocalizationSettings reviewReminder];
	self.postponeLabel.text = [LocalizationSettings postpone];
	self.restorePurchasesLabel.text = [LocalizationSettings restorePurchases];
	
	self.iCloudSwitch.on = self.settings.iCloud;
	
	self.soundsSwitch.on = self.settings.sounds;
	
	self.themeValueLabel.text = [LocalizationSettings theme:GLOBAL.settings.theme];
	self.multilineTilesSwitch.on = self.settings.multilineTitles;
	self.deleteConfirmationSwitch.on = self.settings.deleteConfirmation;
	
	self.iconBadgeSwitch.on = self.settings.notificationBadge;
	
	self.calendarReminderTimeLabel.text = [self.settings.notificationCalendar timeDescription];
	self.overdueReminderTimeLabel.text = [self.settings.notificationOverdue timeDescription];
	self.processReminderTimeLabel.text = [self.settings.notificationProcess timeDescription];
	self.reviewReminderTimeLabel.text = [self.settings.notificationReview timeDescription];
	
	self.postponeTimeLabel.text = [[[[NSDate date] dateComponent] move:self.settings.postponeTime] descriptionForTime:NSDateFormatterShortStyle];

	if (!IOS_8_0) {
		self.multilineTilesLabel.enabled = NO;
		self.multilineTilesSwitch.enabled = NO;
		self.multilineTilesSwitch.enabled = NO;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.section == 1 && indexPath.row == 1 && ![NSBundle isPreferredLocalization:LNG_RU] ? 0.0 : [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
//			[[Crashlytics sharedInstance] crash];
			
			NSString *bundleVersion = [NSBundle bundleVersion];
			
			self.versionLabel.text = [self.versionLabel.text isEqualToString:bundleVersion] ? [NSBundle bundleShortVersionString] : bundleVersion;
		} else if (indexPath.row == 1) {
			[HelpHelper help:self];
		} else if (indexPath.row == 2) {
			[SocialHelper compose:self];
		}
	} else if (indexPath.section == 1) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:indexPath.row ? URL_VKONTAKTE : URL_FACEBOOK]];
	} else if (indexPath.section == 2) {
		[self presentProductWithIdentifier:indexPath.row ? APP_ID_RINGO : APP_ID_LUNA];
	} else if (indexPath.section == 8) {
		[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
	}
	
	[self.tableView selectRowAtIndexPath:Nil animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)iCloudSwitchValueChanged:(UISwitch *)sender {
	[[[UIAlertView alloc] initWithTitle:[LocalizationSettings migrationTitle] message:[LocalizationSettings migrationMessage] delegate:self cancelButtonTitle:[Localization cancel] otherButtonTitles:[Localization ok], Nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	BOOL force = buttonIndex != alertView.cancelButtonIndex;
	[[Workflow instance] migrate:force];
	
	[[self.presentingViewController as:[InBasketController class]] migrate];
}

- (IBAction)soundsSwitchValueChanged:(UISwitch *)sender {
	self.settings.sounds = sender.on;
	
	if (self.settings.sounds)
		[Sounds on];
	else
		[Sounds off];
}

- (IBAction)done:(UIStoryboardSegue *)sender {
	self.themeValueLabel.text = [LocalizationSettings theme:GLOBAL.settings.theme];
}

- (IBAction)multilineTilesSwitchValueChanged:(UISwitch *)sender {
	self.settings.multilineTitles = sender.on;

	[[self.presentingViewController as:[InBasketController class]] reloadTableView:YES];
}

- (IBAction)deleteConfirmationSwitchValueChanged:(UISwitch *)sender {
	self.settings.deleteConfirmation = sender.on;
}

- (IBAction)iconBadgeSwitchValueChanged:(UISwitch *)sender {
	self.settings.notificationBadge = sender.on;
	
	[self.basket scheduleBadgeForToday:NSNotFound];
	[self.basket scheduleBadgeForTomorrow:NSNotFound];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	
	self.segueIdentifier = segue.identifier;
	
	if ([segue.identifier isEqualToString:GUI_THEME]) {
		[segue.destinationViewController endpointViewController].navigationItem.title = [LocalizationSettings theme];
	} else if ([segue.identifier isEqualToString:GUI_POSTPONE]) {
		[DatePickerController setTime:self.settings.postponeTime forViewController:segue.destinationViewController];
		
		[DatePickerController setNavigationTitle:[LocalizationSettings postpone] forViewController:segue.destinationViewController];
	} else if ([segue.identifier isEqualToString:GUI_CALENDAR]) {
		[DatePickerController setNotification:self.settings.notificationCalendar forViewController:segue.destinationViewController];
		
		[DatePickerController setNavigationTitle:[LocalizationSettings calendarReminder] forViewController:segue.destinationViewController];
	} else if ([segue.identifier isEqualToString:GUI_OVERDUE]) {
		[DatePickerController setNotification:self.settings.notificationOverdue forViewController:segue.destinationViewController];
		
		[DatePickerController setNotificationVisible:YES forViewController:segue.destinationViewController];
		
		[DatePickerController setNavigationTitle:[LocalizationSettings overdueReminder] forViewController:segue.destinationViewController];
	} else if ([segue.identifier isEqualToString:GUI_PROCESS]) {
		[DatePickerController setNotification:self.settings.notificationProcess forViewController:segue.destinationViewController];
		
		[DatePickerController setNotificationVisible:YES forViewController:segue.destinationViewController];
		
		[DatePickerController setNavigationTitle:[LocalizationSettings processReminder] forViewController:segue.destinationViewController];
	} else if ([segue.identifier isEqualToString:GUI_REVIEW]) {
		[DatePickerController setNotification:self.settings.notificationReview forViewController:segue.destinationViewController];
		
		[DatePickerController setNotificationVisible:YES forViewController:segue.destinationViewController];
		
		[DatePickerController setNavigationTitle:[LocalizationSettings reviewReminder] forViewController:segue.destinationViewController];
	}
}

- (IBAction)didSelect:(UIStoryboardSegue *)segue {
	if ([self.segueIdentifier isEqualToString:GUI_POSTPONE]) {
		NSDate *postponeDate = [DatePickerController getDate:segue.sourceViewController];
		NSTimeInterval postponeTime = [postponeDate timeComponent];
		
		if (self.settings.postponeTime != postponeTime) {
			self.postponeTimeLabel.text = [postponeDate descriptionForTime:NSDateFormatterShortStyle];
			self.settings.postponeTime = postponeTime;
		}
	} else {
		Notification *notification = [DatePickerController getNotification:segue.sourceViewController];
		
		if ([self.segueIdentifier isEqualToString:GUI_CALENDAR]) {
			if (![self.settings.notificationCalendar isEqualToReminderSettings:notification]) {
				self.calendarReminderTimeLabel.text = [notification timeDescription];
				self.settings.notificationCalendar = notification;
			}
		} else if ([self.segueIdentifier isEqualToString:GUI_OVERDUE]) {
			if (![self.settings.notificationOverdue isEqualToReminderSettings:notification]) {
				self.overdueReminderTimeLabel.text = [notification timeDescription];
				self.settings.notificationOverdue = notification;
				
				[self.basket scheduleOverdueAlert:YES];
			}
		} else if ([self.segueIdentifier isEqualToString:GUI_PROCESS]) {
			if (![self.settings.notificationProcess isEqualToReminderSettings:notification]) {
				self.processReminderTimeLabel.text = [notification timeDescription];
				self.settings.notificationProcess = notification;
				
				[self.basket scheduleProcessAlert:YES];
			}
		} else if ([self.segueIdentifier isEqualToString:GUI_REVIEW]) {
			if (![self.settings.notificationReview isEqualToReminderSettings:notification]) {
				self.reviewReminderTimeLabel.text = [notification timeDescription];
				self.settings.notificationReview = notification;
				
				[self.basket scheduleReviewAlert];
			}
		}
	}
}

- (IBAction)didCancel:(UIStoryboardSegue *)segue {

}

- (void)dismiss:(id <UIPinchTransitionDelegate>)delegate {
	if (delegate) {
		[self dismissViewControllerWithTransition:[UIPinchTransition interactivePinchOut:delegate]];
	} else {
		[self dismissViewControllerWithTransition:[UIPinchTransition animatedPinchOut:DURATION_S]];
		
		[Sounds navigation];
	}
}

- (UIPinchGestureRecognizer *)transitionGestureRecognizer:(UIPinchTransition *)sender {
	return self.pinch;
}

- (void)transitionWillFinish:(UIPinchTransition *)sender {
	[Sounds navigation];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake)
		[self dismiss:Nil];
}

@end
