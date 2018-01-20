//
//  PannableBasketController.m
//  Done!
//
//  Created by Alexander Ivanov on 13.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>

#import "Action+Description.h"
#import "Action+Folder.h"
#import "Action+Process.h"
#import "Action+Send.h"
#import "CalendarController.h"
#import "CloudStatistics+Help.h"
#import "Constants.h"
#import "DelegateController.h"
#import "FolderController.h"
#import "Localization.h"
#import "LocalizationRepeat.h"
#import "PostponeController.h"
#import "RepeatController.h"
#import "ScheduleController.h"
#import "SocialHelper.h"
#import "Sounds.h"

#import "NSArray+Mutable.h"
#import "NSHelper.h"
#import "NSObject+Cast.h"
#import "NSURL+Parse.h"
#import "UIActionSheet+Show.h"
#import "UIActionSheetWithShake.h"
#import "UIActivityViewController+Create.h"
#import "UIAlertViewEx.h"
#import "UIAlertController+Compatibility.h"
#import "UIApplication+ViewController.h"
#import "UIHelper.h"
#import "UIPinchTransition.h"
#import "UITableView+Rows.h"
#import "UIViewController+Hierarchy.h"
#import "UIViewController+Transition.h"

@interface PannableBasket ()
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) NSUInteger calendarIndex;
//@property (assign, nonatomic) BOOL cancel;
@end

@implementation PannableBasket

- (void)presentViewController:(UIViewController *)viewController fromView:(UIView *)view {
	if ([viewController isKindOfClass:[BasketController class]])
		[self presentViewController:viewController withTransition:[UIPinchTransition animatedPinchOut:DURATION_S]];
	else
		[self presentViewController:viewController animated:YES completion:Nil];
}

- (void)dismissViewController:(BOOL)animated completion:(void (^)(void))completion {
	if ([self.presentedViewController isKindOfClass:[BasketController class]] && animated)
		[self dismissViewControllerWithTransition:[UIPinchTransition animatedPinchIn:DURATION_S] andCompletion:completion];
	else
		[self dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissViewController:(BOOL)animated {
	[self dismissViewController:animated completion:Nil];
}

- (void)performSegue:(NSString *)identifier fromView:(UIView *)view {
	[self performSegueWithIdentifier:identifier sender:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	[self action:buttonIndex == actionSheet.cancelButtonIndex ? ALERT_CANCEL
		: buttonIndex == actionSheet.destructiveButtonIndex ? ALERT_DESTRUCTIVE
		: [buttonTitle isEqualToString:[Localization undoAction]] ? ALERT_UNDO
		: [buttonTitle isEqualToString:[Localization moveToInBasket]] ? ALERT_MOVE
		: buttonIndex with:self.indexPath];
}

- (void)action:(NSInteger)buttonIndex with:(NSIndexPath *)indexPath {
	PannableCell *cell = [[self.tableView cellForRowAtIndexPath:indexPath] as:[PannableCell class]];
	
	if (buttonIndex == ALERT_CANCEL) {															// cancel
		[cell cancel];
	} else if (buttonIndex == ALERT_DESTRUCTIVE) {												// remove
		[Sounds remove];
		
		[cell done];
		
		[self remove:indexPath];
		
		self.statistics.endPanRemove++;
	} else if (buttonIndex == ALERT_DO) {														// do
		[Sounds done];
		
		[cell done];
		
		[self done:indexPath];
		
		[self.statistics incrementDone];
		
		[SocialHelper compose:self alert:YES];
	} else if (buttonIndex == ALERT_UNDO) {														// undo
		[Sounds undone];
		
		[cell done];
		
		[self undone:indexPath];
		
		[self.statistics decrementDone];
	} else if (buttonIndex == ALERT_MOVE) {														// move
		[Sounds undone];
		
		[cell done];
		
		[self inBasket:indexPath];
	}
	
	[self updateTourPrompt];
	
	self.actionSheet = Nil;
	
//	[self resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	
	[self prepareProcess:[segue.destinationViewController endpointViewController]];
}

- (IBAction)didSelect:(UIStoryboardSegue *)segue {
	[self doneProcess:[segue.sourceViewController endpointViewController]];
}

- (IBAction)didCancel:(UIStoryboardSegue *)segue {
//	self.cancel = YES;
}

- (void)didPan:(PannableCell *)sender fromUnit:(PannableUnit *)unit {
	 if ((!sender.selectedUnit.title && unit.title && unit == sender.unit) || (!unit.title && sender.selectedUnit.title && sender.selectedUnit == sender.unit) || (!sender.selectedUnit.title && !unit.title))
		 return;
	
	[Sounds beginProcess];
}

- (void)didPan:(PannableCell *)sender toOffset:(CGFloat)offset {
	NSArray *units = offset < 0.0 ? sender.rightUnits : sender.leftUnits;
	
	CGFloat focus = fabs(offset) / ((PannableUnit *)[units firstObject]).width * self.table.maxFocusValue;
	[self.table setFocus:focus forCells:ARRAY(sender) withDuration:0];
	
	CGFloat width = 0.0;
	NSUInteger count = [units count] - (offset < 0.0 || sender.imageView.hidden ? 1 : 2);
	for (NSUInteger index = 0; index < count; index++)
		width += ((PannableUnit *)units[index]).width;
	[sender setArrowByTranslation:!self.onboarding && ((offset > 0.0 && offset < width && [self.statistics hintLeft]) || (offset < 0.0 && -offset < width && [self.statistics hintRight])) ? offset : 0.0];
}

- (void)didCancelPanning:(PannableCell *)sender {
	[self.table defocusWithDuration:0];
}

- (void)willEndPanning:(PannableCell *)sender {
	[self.table defocusWithDuration:DURATION_XS];
	
	if (!sender.selectedUnit || sender.selectedUnit == sender.unit)
		return;
	
	[self playSound:sender];
}

- (void)didEndPanning:(PannableCell *)sender {
	if (!sender.selectedUnit || sender.selectedUnit == sender.unit)
		return;
	
	BOOL modal = [self process:sender];
	
	if (!modal)
		[self updateTourPrompt];
}

- (void)didTap:(PannableCell *)sender {
	[Sounds endProcess];
	
	BOOL modal = [self process:sender];
	
	if (!modal)
		[self updateTourPrompt];
}

- (void)didEnter:(EnterableCell *)sender {
//	if (sender.rightUnits.count == 2)
//		return;
	
	self.indexPath = [self.tableView indexPathForCell:sender];
	NSUInteger row = [self rowForIndexPath:self.indexPath];
	Action *action = [self.basket index:row];
	
	if (action.folder) {
		[sender.title burst:GUI_BURST_SCALE duration:DURATION_XXXS];
		
		if ([UIHelper iPad:self])
			[Sounds endProcess];
		else
			[Sounds navigation];
		
		self.statistics.beginFolder++;
		
		UIViewController *folder = [[self storyboard] instantiateViewControllerWithIdentifier:GUI_FOLDER];
//		[FolderController setValues:action.folderValues andTitle:action.title forViewController:folder];
		[self prepareProcess:folder];
		[self presentViewController:folder fromView:Nil];
	} else if (action.repeat) {
		[sender.subtitle burst:GUI_BURST_SCALE duration:DURATION_XXXS];
		
		[Sounds endProcess];
		
		self.statistics.beginRepeat++;
			
		[self performSegue:GUI_REPEAT fromView:[sender anchor]];
	} else if (action.state) {
		if (!sender.imageView.hidden)
			[sender.imageView burst:GUI_BURST_SCALE duration:DURATION_XXXS animation:^{
				sender.imageView.image = sender.selectedUnit.highlightImage;
				sender.imageView.tintColor = sender.fullColor;
			} completion:Nil];
		
		[Sounds endProcess];
		
		[self process:sender];
	}
}

- (void)playSound:(PannableCell *)sender {
	if ([sender.selectedUnit.title isEqualToString:GTD_ACTION_STATE_DESCRIPTION_DONE])
		[Sounds done];
	else if ([sender.selectedUnit.title isEqualToString:GUI_REMOVE] && !self.settings.deleteConfirmation)
		[Sounds remove];
	else if ([sender.selectedUnit.title isEqualToString:GUI_FOLDER])
		[Sounds navigation];
	else if ([sender.selectedUnit.title isEqualToString:GUI_SEND])
		[Sounds compose];
	else if (sender.selectedUnit.title)
		[Sounds endProcess];
}

- (BOOL)process:(PannableCell *)sender {
	self.indexPath = [self.tableView indexPathForCell:sender];

//	[[Crashlytics sharedInstance] setBoolValue:self.settings.iCloud forKey:@"iCloud"];
//	[[Crashlytics sharedInstance] setObjectValue:[[NSLocale currentLocale] localeIdentifier] forKey:@"Locale"];
//	[[Crashlytics sharedInstance] setObjectValue:sender.selectedUnit.title forKey:@"Process"];
	
	if ([sender.selectedUnit.title isEqualToString:GTD_ACTION_STATE_DESCRIPTION_DONE]) {
		if (sender.selectedUnit == sender.unit) {
			if (IOS_8_0) {
				__weak PannableBasket *__self = self;
				UIAlertController *alert = [UIAlertController actionSheetWithTitle:Nil message:Nil cancelButtonTitle:[Localization cancel] destructiveButtonTitle:Nil otherButtonTitles:@[ [Localization undoAction] ] completion:^(UIAlertController *instance, NSInteger index) {
					[__self action:index < 0 || index == ALERT_CANCEL || index == ALERT_DESTRUCTIVE ? index : ALERT_UNDO with:__self.indexPath];
				}];
				[self presentViewController:alert fromView:[sender anchor]];
			} else {
				self.actionSheet = [[UIActionSheetWithShake alloc] initWithTitle:Nil delegate:self cancelButtonTitle:[Localization cancel] destructiveButtonTitle:Nil otherButtonTitles:[Localization undoAction], Nil];
				[self.actionSheet showFromView:[sender anchor] inSuperview:self.view];
			}
			
			return YES;
		} else {
			[sender done];
			
			[self done:self.indexPath];
			
			[self.statistics incrementDone];
			
			[SocialHelper compose:self alert:YES];
			
			return NO;
		}
	} else if ([sender.selectedUnit.title isEqualToString:GTD_ACTION_STATE_DESCRIPTION_DEFERRAL]) {
		self.statistics.beginDeferral++;

		self.calendarIndex = 0;
		[self performSegue:GTD_ACTION_STATE_DESCRIPTION_CALENDAR fromView:[sender anchor]];
		
		return YES;
	} else if ([sender.selectedUnit.title isEqualToString:GTD_ACTION_STATE_DESCRIPTION_CALENDAR]) {
		self.statistics.beginCalendar++;
		
		self.calendarIndex = 1;
		[self performSegue:GTD_ACTION_STATE_DESCRIPTION_CALENDAR fromView:[sender anchor]];
		
		return YES;
	} else if ([sender.selectedUnit.title isEqualToString:GTD_ACTION_STATE_DESCRIPTION_DELEGATE]) {
		self.statistics.beginDelegate++;
		
		self.calendarIndex = 2;
		[self performSegue:GTD_ACTION_STATE_DESCRIPTION_CALENDAR fromView:[sender anchor]];
		
		return YES;
	} else if ([sender.selectedUnit.title isEqualToString:GUI_REMOVE]) {
		if (self.settings.deleteConfirmation) {
			self.statistics.beginPanRemove++;

			Action *action = [self.basket index:[self rowForIndexPath:self.indexPath]];
			NSString *deleteButtonTitle = action.folder ? [Localization deleteFolder] : [Localization deleteAction];
			NSString *moveButtonTitle = action.state ? [Localization moveToInBasket] : Nil;

			if (IOS_8_0) {
				__weak PannableBasket *__self = self;
				UIAlertController *alert = [UIAlertController actionSheetWithTitle:Nil message:Nil cancelButtonTitle:[Localization cancel] destructiveButtonTitle:deleteButtonTitle otherButtonTitles:ARRAY(moveButtonTitle) completion:^(UIAlertController *instance, NSInteger index) {
					[__self action:index < 0 || index == ALERT_CANCEL || index == ALERT_DESTRUCTIVE ? index : ALERT_MOVE with:__self.indexPath];
				}];
				[self presentViewController:alert fromView:[sender anchor]];
			} else {
				self.actionSheet = [[UIActionSheetWithShake alloc] initWithTitle:Nil delegate:self cancelButtonTitle:[Localization cancel] destructiveButtonTitle:deleteButtonTitle otherButtonTitles:moveButtonTitle, Nil];
				[self.actionSheet showFromView:[sender anchor] inSuperview:self.view];
			}
			
			return YES;
		} else {
			[sender done];
			
			[self remove:self.indexPath];
			
			self.statistics.endPanRemove++;
			
			return NO;
		}
	} else if ([sender.selectedUnit.title isEqualToString:GUI_REPEAT]) {
		self.statistics.beginRepeat++;
		
		[self performSegue:GUI_REPEAT fromView:[sender anchor]];
		
		return YES;
	} else if ([sender.selectedUnit.title isEqualToString:GUI_FOLDER]) {
		self.statistics.beginFolder++;
		
		UIViewController *folder = [[self storyboard] instantiateViewControllerWithIdentifier:GUI_FOLDER];
		[self prepareProcess:folder];
		[self presentViewController:folder fromView:[sender anchor]];
		
		return YES;
	} else if ([sender.selectedUnit.title isEqualToString:GUI_SEND]) {
		self.statistics.beginSend++;
		
		Action *action = [self.basket index:[self rowForIndexPath:self.indexPath]];
		NSURL *url = [action exportToFile];
		NSArray *array = [NSArray arrayWithObject:[action actionDescription] withObject:[[NSURL URLWithString:URL_SHARE] URLByAppendingQueryDictionary:[action exportToDictionary]] withObject:url];
		
		if (array) {
			__weak PannableBasket *__self = self;
			UIActivityViewController *vc = [UIActivityViewController createWebActivityWithItems:array andExcludedTypes:@[ UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard ] completion:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
				if (completed)
					__self.statistics.endSend++;
				
				[[NSFileManager defaultManager] removeItemAtURL:url error:Nil];
				
				[__self cancelProcess];
			}];
			
			[self presentViewController:vc fromView:[sender anchor]];
			
			return YES;
		}
	}
	
	return NO;
}

- (void)prepareProcess:(UIViewController *)viewController {
	NSUInteger row = [self rowForIndexPath:self.indexPath];
	Action *action = [self.basket index:row];
	
	if ([viewController isKindOfClass:[CalendarController class]])
		[CalendarController setDate:[action dateForCalendarController] repeat:action.repeatInterval sound:action.soundName alert:action.alertInterval person:action.person name:action.personDescription index:self.calendarIndex forViewController:viewController];
	else if ([viewController isKindOfClass:[RepeatController class]])
		[RepeatController setValues:action.repeatValues andCount:action.repeatCount forViewController:viewController];
	else if ([viewController isKindOfClass:[FolderController class]])
		[FolderController setValues:action.folderValues andTitle:action.title forViewController:viewController];
}

- (void)doneProcess:(UIViewController *)viewController {
	if ([viewController isKindOfClass:[UIPageViewController class]])
		viewController = ((UIPageViewController *)viewController).viewControllers.firstObject;
	
	if ([viewController isKindOfClass:[ABPersonViewController class]])
		return;
	
	PannableCell *cell = [[self.tableView cellForRowAtIndexPath:self.indexPath] as:[PannableCell class]];
	[cell done];
	
	if ([viewController isKindOfClass:[PostponeController class]]) {
		[Sounds organize];
		
		[self deferral:self.indexPath date:[PostponeController getDate:viewController]];
		
		self.statistics.endDeferral++;
	} else if ([viewController isKindOfClass:[ScheduleController class]]) {
		[Sounds organize];
		
		[self calendar:self.indexPath date:[ScheduleController getDate:viewController] repeat:@([ScheduleController getRepeat:viewController]) sound:[ScheduleController getSound:viewController] alert:@([ScheduleController getAlert:viewController])];
		
		self.statistics.endCalendar++;
	} else if ([viewController isKindOfClass:[DelegateController class]]) {
		[Sounds organize];

		[self delegate:self.indexPath owner:[DelegateController getID:viewController] ownerDescription:[DelegateController getName:viewController]];
		
		self.statistics.endDelegate++;
	} else if ([viewController isKindOfClass:[RepeatController class]]) {
		[Sounds organize];
		
		NSArray *values = [RepeatController getValues:viewController];
		if (((NSNumber *)values.firstObject).unsignedIntegerValue == NSUIntegerMax)
			[self skip:self.indexPath];
		else
			[self repeat:self.indexPath values:values];
		
		self.statistics.endRepeat++;
	} else if ([viewController isKindOfClass:[FolderController class]]) {
		// no sound
		
		[self.tableView reloadRowAtIndexPath:self.indexPath withAnimation:UITableViewRowAnimationAutomatic];
		
		self.statistics.endFolder++;
	}
	
	[self updateTourPrompt];
	
	self.indexPath = Nil;
}

- (void)cancelProcess {
	PannableCell *cell = [[self.tableView cellForRowAtIndexPath:self.indexPath] as:[PannableCell class]];
	[cell cancel];
	
	[self updateTourPrompt];
	
//	self.cancel = NO;
	
	self.indexPath = Nil;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
//	if (self.cancel)
	if (self.indexPath)
		[self cancelProcess];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (self.actionSheet && motion == UIEventSubtypeMotionShake)
		[self.actionSheet motionEnded:motion withEvent:event];
	else if ([self.presentedViewController isKindOfClass:[UIAlertController class]])
		[self.presentedViewController dismissViewControllerAnimated:YES completion:^{
			[self action:ALERT_CANCEL with:self.indexPath];
		}];
	else if ([self.presentedViewController isKindOfClass:[UIActivityViewController class]])
		[self.presentedViewController dismissViewControllerAnimated:YES completion:^{
			[self cancelProcess];
		}];
	else
		[super motionEnded:motion withEvent:event];
}

@end
