//
//  CalendarController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 07.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "AlertController.h"
#import "Constants.h"
#import "Images.h"
#import "Localization.h"
#import "LocalizationRating.h"
#import "LocalizationRepeat.h"
#import "NotificationHelper.h"
#import "NSBundle+Convenience.h"
#import "NSDate+Calculation.h"
#import "NSDate+Description.h"
#import "NSHelper.h"
#import "Palette.h"
#import "RateView.h"
#import "ScheduleController.h"
#import "SocialHelper.h"
#import "SoundsController.h"
#import "Statistics+Social.h"
#import "UIApplication+ViewController.h"
#import "UIDatePickerController.h"
#import "UIHelper.h"
#import "UIFont+Modification.h"
#import "UIImageCache.h"
#import "UIScrollView+Scroll.h"
#import "UIView+Position.h"
#import "UIViewController+Hierarchy.h"
#import "Workflow.h"

#define DATE_LINE @"date-line"
#define DATE_FULL @"date-full"
#define CLOCK_LINE @"clock-line"
#define CLOCK_FULL @"clock-full"
#define REPEAT_LINE @"repeat-line"
#define REPEAT_FULL @"repeat-full"

@interface ScheduleController ()
@property (weak, nonatomic) IBOutlet UIImageView *dateImage;
@property (weak, nonatomic) IBOutlet UILabel *dateTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateDetail;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UILabel *timeTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeDetail;
@property (weak, nonatomic) IBOutlet UIImageView *repeatImage;
@property (weak, nonatomic) IBOutlet UILabel *repeatTitle;
@property (weak, nonatomic) IBOutlet UISwitch *repeatSwitch;
@property (weak, nonatomic) IBOutlet UILabel *alertTitle;
@property (weak, nonatomic) IBOutlet UILabel *alertDetail;
@property (weak, nonatomic) IBOutlet UILabel *soundTitle;
@property (weak, nonatomic) IBOutlet UILabel *soundDetail;
@property (weak, nonatomic) IBOutlet RateView *rateView;

@property (strong, nonatomic) UIDatePickerController *pickerController;

@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL repeat;
@property (strong, nonatomic) NSString *sound;
@property (assign, nonatomic) NSTimeInterval alert;

@property (assign, nonatomic) NSUInteger appear;
@end

@implementation ScheduleController

+ (NSDate *)getDate:(UIViewController *)controller {
	return [ScheduleController viewController:controller].date;
}

+ (BOOL)getRepeat:(UIViewController *)controller {
	return [ScheduleController viewController:controller].repeat;
}

+ (NSString *)getSound:(UIViewController *)controller {
	return [ScheduleController viewController:controller].sound;
}

+ (NSTimeInterval)getAlert:(UIViewController *)controller {
	return [ScheduleController viewController:controller].alert;
}

+ (void)setDate:(NSDate *)date repeat:(BOOL)repeat sound:(NSString *)sound alert:(NSTimeInterval)alert forViewController:(UIViewController *)controller {
	ScheduleController *vc = [ScheduleController viewController:controller];
	
	vc.date = date;
	vc.repeat = repeat;
	vc.sound = [NSBundle resourceExists:sound] ? sound : [Workflow instance].settings.notificationCalendar.sound;
	vc.alert = alert;
}

- (UIDatePickerController *)pickerController {
	if (!_pickerController) {
		_pickerController = [[UIDatePickerController alloc] initWithView:self.view];
		_pickerController.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
		_pickerController.datePicker.date = self.date;
		_pickerController.datePicker.minimumDate = [self.date isPast] ? self.date : [NSDate date];
		[_pickerController.doneButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];

		__weak ScheduleController *__self = self;
		_pickerController.datePickerValueChanged = ^(UIDatePicker *sender, NSIndexPath *indexPath) {
			[__self pickerValueChanged:sender];
		};
		_pickerController.identifierValueChanged = ^(UIDatePicker *sender, NSIndexPath *indexPath) {
			[__self setMode:indexPath ? indexPath.row ? UIDatePickerModeTime : UIDatePickerModeDate : UIDatePickerModeDateAndTime];
		};
	}

	return _pickerController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self.tableView setContentInsetTop:self.tableView.contentInset.top + self.navigationController.navigationBar.frame.size.height];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.repeatSwitch.onTintColor = [Palette red];
	
	self.dateTitle.text = [Localization date];
	self.dateDetail.text = [self.date descriptionForDate:NSDateFormatterFullStyle];
	
	self.timeTitle.text = [Localization time];
	self.timeDetail.text = [self.date descriptionForTime:NSDateFormatterShortStyle];
	
	self.repeatTitle.text = [LocalizationRepeat repeat];
	self.repeatSwitch.on = self.repeat;
	self.repeatImage.highlighted = self.repeatSwitch.on;
	
	self.alertTitle.text = [Localization alert];
	self.alertDetail.text = [AlertController alertDisplayName:self.alert];
	
	self.soundTitle.text = [Localization sound];
	self.soundDetail.text = [SoundsController soundDisplayName:self.sound];
	
	if (self.appear)
		return;
	
	self.rateView.image = GLOBAL.statistics.appStore ? [Images starsFull] : [Images starsLine];
	self.rateView.text = [LocalizationRating message];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[NotificationHelper request];
	
	if (self.appear)
		return;
	self.appear++;
	
	if (GLOBAL.statistics.appStore)
		return;
	
	__weak ScheduleController *__self = self;
	[self.rateView.imageView shake:UIDirectionRight duration:DURATION_M delay:0.0 animation:^{
		__self.rateView.image = [Images starsFull];
	} completion:Nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger number = [super numberOfSectionsInTableView:tableView];
	
	Statistics *statistics = [Workflow instance].statistics;
	if (!([statistics weekFromFirstLaunch] && [statistics monthFromAppStore]) && !IS_DEBUGGING)
		number--;
	
	return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		self.pickerController.indexPath = indexPath;
	} else if (indexPath.section == 3) {
		[self.rateView open:URL_APP_STORE withDuration:0];
		
		[Workflow instance].statistics.appStore = [NSDate date];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return section == 1 ? [LocalizationRepeat message] : [super tableView:tableView titleForFooterInSection:section];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	
	UIViewController *destination = [segue.destinationViewController endpointViewController];
	if ([destination isKindOfClass:[SoundsController class]]) {
		__weak ScheduleController *__self = self;
		[SoundsController setSound:self.sound andChanged:^(NSString *sound) {
			__self.sound = sound;
			
			__self.soundDetail.text = [SoundsController soundDisplayName:sound];
		} forViewController:segue.destinationViewController];
	} else if ([destination isKindOfClass:[AlertController class]]) {
		__weak ScheduleController *__self = self;
		[AlertController setAlert:self.alert andChanged:^(NSTimeInterval alert) {
			__self.alert = alert;
			
			__self.alertDetail.text = [AlertController alertDisplayName:alert];
		} forViewController:segue.destinationViewController];
	}
	
	destination.view.tintColor = self.view.tintColor;
}

- (IBAction)pickerValueChanged:(UIDatePicker *)sender {
	self.date = sender.date;
	
	self.dateDetail.text = [self.date descriptionForDate:NSDateFormatterFullStyle];
	self.timeDetail.text = [self.date descriptionForTime:NSDateFormatterShortStyle];
}

- (IBAction)repeatSwitchValueChanged:(UISwitch *)sender {
	self.repeat = self.repeatSwitch.on;
	self.repeatImage.highlighted = self.repeatSwitch.on;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	if (!_pickerController)
		return;
	
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		self.pickerController.datePicker.frame = CGRectMake(self.view.bounds.origin.x, self.pickerController.datePicker.hidden ? size.height : size.height - self.tableView.contentInset.top - self.pickerController.datePicker.frame.size.height, size.width, self.pickerController.datePicker.frame.size.height);
	} completion:Nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([UIHelper iPhone:self] && scrollView.isDragging && scrollView.contentOffset.y < scrollView.bounds.size.height / -3.0) {
		__weak ScheduleController *__self = self;
		if (self.completion)
			self.completion(__self, NO);
	}
	
	if (!_pickerController)
		return;
	
	self.pickerController.indexPath = Nil;
//	[self.picker setOriginY:self.picker.hidden ? self.tableView.bounds.size.height : self.tableView.bounds.size.height - _picker.frame.size.height + scrollView.contentOffset.y];
}

- (void)setMode:(UIDatePickerMode)mode {
	self.dateDetail.font = mode == UIDatePickerModeDate ? [self.dateDetail.font bold] : [self.dateDetail.font original];
	self.dateDetail.textColor = mode == UIDatePickerModeDate ? self.view.tintColor : [UIColor darkTextColor];
	[self.dateDetail.superview.superview layoutSubviews];
	self.timeDetail.font = mode == UIDatePickerModeTime ? [self.timeDetail.font bold] : [self.timeDetail.font original];
	self.timeDetail.textColor = mode == UIDatePickerModeTime ? self.view.tintColor : [UIColor darkTextColor];
	[self.timeDetail.superview.superview layoutSubviews];
	
	self.dateImage.image = [IMG_CACHE originalImage:mode == UIDatePickerModeDate ? DATE_FULL : DATE_LINE];
	self.timeImage.image = [IMG_CACHE originalImage:mode == UIDatePickerModeTime ? CLOCK_FULL : CLOCK_LINE];

	if (mode != UIDatePickerModeDateAndTime)
		self.pickerController.datePicker.datePickerMode = mode;
}

@end
