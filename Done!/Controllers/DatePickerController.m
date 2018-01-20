//
//  DatePickerController.m
//  Done!
//
//  Created by Alexander Ivanov on 13.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "DatePickerController.h"
#import "Constants.h"
#import "Images.h"
#import "Localization.h"
#import "LocalizationRating.h"
#import "LocalizationRepeat.h"
#import "NotificationHelper.h"
#import "Palette.h"
#import "RateView.h"
#import "SocialHelper.h"
#import "SoundsController.h"
#import "Statistics+Social.h"
#import "Workflow.h"

#import "ASHelper.h"
#import "NSBundle+Convenience.h"
#import "NSDate+Calculation.h"
#import "NSObject+Cast.h"
#import "UIApplication+ViewController.h"
#import "UIHelper.h"
#import "UIView+Animation.h"
#import "UIView+Gestures.h"
#import "UIView+Presentation.h"
#import "UIViewController+Hierarchy.h"

#define CELL_ID @"sounds"

@interface DatePickerController()
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSDate *minimumDate;
@property (assign, nonatomic) UIDatePickerMode mode;

@property (assign, nonatomic) BOOL reminderOn;
@property (strong, nonatomic) NSString *soundName;
@property (assign, nonatomic) BOOL notificationVisible;
@property (strong, nonatomic) NSString *navigationTitle;

@property (strong, nonatomic) RateView *rateView;

@property (assign, nonatomic) NSUInteger didAppear;

@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation DatePickerController

@synthesize popoverDelegate = _popoverDelegate;

+ (NSDate *)getDate:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	return vc.datePicker.date;
}

+ (BOOL)getRepeat:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	return vc.reminderOn;
}

+ (NSString *)getSound:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	return vc.soundName;
}

+ (void)setDate:(NSDate *)date repeat:(BOOL)repeat andSound:(NSString *)sound forViewController:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	
	NSDate *now = [NSDate date];
	
	vc.mode = UIDatePickerModeDateAndTime;
	vc.date = date;
	vc.minimumDate = [vc.date isLessThanOrEqual:now] ? vc.date : now;
	
	vc.reminderOn = repeat;
	
	vc.soundName = [NSBundle resourceExists:sound] ? sound : [Workflow instance].settings.notificationCalendar.sound;
}

+ (BOOL)getNotificationVisible:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	return vc.notificationVisible;
}

+ (void)setNotificationVisible:(BOOL)visible forViewController:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	vc.notificationVisible = visible;
}

+ (void)setNavigationTitle:(NSString *)title forViewController:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	vc.navigationTitle = title;
}

+ (Notification *)getNotification:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	
	return [Notification create:vc.reminderOn :vc.soundName :[vc.date timeComponent]];
}

+ (void)setNotification:(Notification *)notification forViewController:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	
	vc.reminderOn = notification.on;
	vc.soundName = notification.sound;
	vc.date = [[[NSDate date] dateComponent] move:notification.time];
}

+ (void)setTime:(NSTimeInterval)time forViewController:(UIViewController *)controller {
	DatePickerController *vc = [DatePickerController viewController:controller];
	
	vc.date = [[[NSDate date] dateComponent] move:time];
}

- (IBAction)reminderSwitchValueChanged:(UISwitch *)sender {
	self.datePicker.enabled = sender.on;
	
	self.reminderOn = sender.on;
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
	self.date = sender.date;
}

// sounds

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
	
	cell.textLabel.text = [Localization sound];
	cell.detailTextLabel.text = [SoundsController soundDisplayName:self.soundName];
	
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	
	if ([[segue.destinationViewController endpointViewController] isKindOfClass:[SoundsController class]])
		[SoundsController setSound:self.soundName andChanged:^(NSString *sound) {
			self.soundName = sound;
			
			[self.table reloadData];
		} forViewController:segue.destinationViewController];
}
/*
- (IBAction)didSelect:(UIStoryboardSegue *)segue {
	[ASHelper stopAll];
	
	if ([[segue.sourceViewController endpointViewController] isKindOfClass:[SoundsController class]]) {
		self.soundName = [SoundsController getSound:segue.sourceViewController];
		
		[self.table reloadData];
	}
}

- (IBAction)didCancel:(UIStoryboardSegue *)segue {
	[ASHelper stopAll];
}
*/
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.table.dataSource = self;
	self.table.delegate = self;
	
	self.datePicker.datePickerMode = self.mode;
	if (self.date)
		self.datePicker.date = self.date;
	if (self.minimumDate)
		self.datePicker.minimumDate = self.minimumDate;
	
	self.date = self.datePicker.date;
}

// sounds

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (self.didAppear)
		return;
	
	self.navigationItem.title = self.navigationTitle;
	
	self.reminderLabel.text = self.mode != UIDatePickerModeDateAndTime ? [Localization enabled] : [LocalizationRepeat repeat];
	self.reminderSwitch.on = self.reminderOn;
	
	self.reminderLabel.hidden = !self.notificationVisible && self.mode != UIDatePickerModeDateAndTime;
	self.reminderSwitch.hidden = !self.notificationVisible && self.mode != UIDatePickerModeDateAndTime;
	self.table.hidden = !self.notificationVisible && self.mode != UIDatePickerModeDateAndTime && !self.soundName;
	
	self.titleLabel.text = [LocalizationRepeat message];
	self.titleLabel.hidden = self.mode != UIDatePickerModeDateAndTime;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.didAppear)
		return;
	
	self.didAppear++;

	if (self.mode != UIDatePickerModeDateAndTime)
		return;
	
	[NotificationHelper request];
	
	__strong Statistics *statistics = [Workflow instance].statistics;
	if (![statistics weekFromFirstLaunch] || ![statistics monthFromAppStore])
		return;

	self.rateView = [[RateView alloc] initWithFrame:CGRectMake([UIHelper margin:self], self.datePicker.frame.origin.y + self.datePicker.frame.size.height, self.view.bounds.size.width - [UIHelper margin:self] * 2, 44.0)];
	[self.view addSubview:self.rateView];
	
	self.rateView.hidden = YES;
	self.rateView.image = [Images starsFull];
	self.rateView.text = [LocalizationRating message];
	
	[self.rateView addTap:self :@selector(rateViewTap:)];
	[self.rateView border:2.0 :[Palette iosGray]];
	[self.rateView circle:2.0];
	
	if (self.view.frame.size.height > self.view.frame.size.width)
		[self.rateView animateShowWithDuration:DURATION_L];
}
/*
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	self.rateView.hidden = !(self.mode == UIDatePickerModeDateAndTime && [statistics weekFromFirstLaunch] && [statistics monthFromAppStore] && size.height > size.width);
}
*/
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	Statistics *statistics = [Workflow instance].statistics;
	self.rateView.hidden = !(self.mode == UIDatePickerModeDateAndTime && [statistics weekFromFirstLaunch] && [statistics monthFromAppStore] && ([UIHelper iPad:self] || UIInterfaceOrientationIsPortrait(toInterfaceOrientation)));
}

- (IBAction)rateViewTap:(UIButton *)sender {
	[self.rateView open:URL_APP_STORE withDuration:DURATION_XXS];
	
	[Workflow instance].statistics.appStore = [NSDate date];
}

- (void)dismiss:(UIViewController *)controller {
	if ([self.popoverDelegate respondsToSelector:@selector(shouldDismissPopover:)])
		[self.popoverDelegate shouldDismissPopover:controller];
	else
		[self performSegueWithIdentifier:controller ? GUI_SELECT : GUI_CANCEL sender:self];
}

- (IBAction)doneButtonTap:(UIBarButtonItem *)sender {
	[self dismiss:self];
}

- (IBAction)cancelButtonTap:(UIBarButtonItem *)sender {
	[self dismiss:Nil];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake)
		[self dismiss:Nil];
}

@end
