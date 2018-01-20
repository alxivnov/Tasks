//
//  RepeatController.m
//  Done!
//
//  Created by Alexander Ivanov on 13.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ADClient+Convenience.h"
#import "Constants.h"
#import "DateHelper.h"
#import "HelpHelper.h"
#import "Images.h"
#import "Localization.h"
#import "LocalizationPurchase.h"
#import "LocalizationRating.h"
#import "LocalizationRepeat.h"
#import "NSArray+Query.h"
#import "NSHelper.h"
#import "NSObject+Cast.h"
#import "Palette.h"
#import "PopoverBasket.h"
#import "RateView.h"
#import "RepeatController.h"
#import "SKReceiptObserver.h"
#import "SLHelper.h"
#import "SocialHelper.h"
#import "Statistics+Social.h"
#import "UIApplication+ViewController.h"
#import "UICalendarMonthView.h"
#import "UICalendarWeekView.h"
#import "UIView+Animation.h"
#import "UIViewController+Alert.h"
#import "UIViewController+Hierarchy.h"
#import "UIViewController+Purchase.h"
#import "Workflow.h"

@import iAd;

@interface RepeatController ()
@property (strong, nonatomic) SKInAppPurchase *purchase;

@property (strong, nonatomic) NSArray* values;
@property (assign, nonatomic) NSUInteger count;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmented;

@property (weak, nonatomic) IBOutlet UICalendarMonthView *monthView;
@property (weak, nonatomic) IBOutlet UICalendarWeekView *weekView;

@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UIStepper *periodStepper;

@property (weak, nonatomic) IBOutlet UILabel *skipLabel;

@property (weak, nonatomic) IBOutlet RateView *rateView;

@property (assign, nonatomic) NSUInteger appear;
@end

@implementation RepeatController

@synthesize popoverDelegate = _popoverDelegate;

- (SKInAppPurchase *)purchase {
	if (!_purchase)
		_purchase = [APP_RECEIPT purchaseByIdentifier:[Constants inAppPurchaseRepeat]];
	
	return _purchase;
}

+ (NSArray *)getValues:(UIViewController *)controller {
	RepeatController *vc = [RepeatController viewController:controller];
	return vc.values;
}

+ (void)setValues:(NSArray *)values andCount:(NSUInteger)count forViewController:(UIViewController *)controller {
	RepeatController *vc = [RepeatController viewController:controller];
	vc.values = values;
	vc.count = count;
}

- (IBAction)periodSegmentedValueChanged:(UISegmentedControl *)sender {
	self.monthView.enabled = sender.selectedSegmentIndex == 0;
	
	self.weekView.enabled = sender.selectedSegmentIndex == 1;
	
	self.periodLabel.enabled = sender.selectedSegmentIndex == 2;
	self.periodStepper.enabled = sender.selectedSegmentIndex == 2;
}

- (IBAction)periodStepperValueChanged:(UIStepper *)sender {
	self.periodLabel.text = [DateHelper dayCountDescription:self.periodStepper.value];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == 3 || indexPath.section == 4) && [tableView cellForRowAtIndexPath:indexPath].textLabel.enabled ? indexPath : Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 3) {
		self.values = @[ @(NSUIntegerMax) ];
	
		[self performSegueWithIdentifier:GUI_SELECT sender:self];//[self doneButtonTap:Nil];
	} else if (indexPath.section == 4) {
		[self.rateView open:URL_APP_STORE withDuration:0];
		
		[Workflow instance].statistics.appStore = [NSDate date];
	}
		
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section == 0 ? [LocalizationRepeat monthly]
		: section == 1 ? [LocalizationRepeat weekly]
		: section == 2 ? [LocalizationRepeat daily]
		: section == 3 ? [NSString stringWithFormat:[LocalizationRepeat repeated], @(self.count)]
		: section == 4 ? APP_STORE
		: [super tableView:tableView titleForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return section == 0 ? 30
		: section > 0 && section < 5 ? 20
		: [super tableView:tableView heightForHeaderInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger number = [super numberOfSectionsInTableView:tableView];
	
	Statistics *statistics = [Workflow instance].statistics;
	if (!(self.purchase.purchased && [statistics monthFromAppStore]) && !IS_DEBUGGING)
		number--;
	
	return number;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([UIHelper iPhone:self] && scrollView.isDragging && scrollView.contentOffset.y < scrollView.bounds.size.height / -3.0)
		[self cancelButtonTap:Nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIViewController *vc = [PopoverBasket isPopover:self] ? [[UIApplication sharedApplication] rootViewController] : self;
	vc.canDisplayBannerAds = IS_DEBUGGING || !self.purchase.purchased;
		
	self.navigationController.navigationBar.tintColor = [Palette orange];
	self.view.tintColor = [Palette orange];
	self.skipLabel.textColor = [Palette orange];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSUInteger firstNumber = [[self.values firstObject] integerValue];
	
	[self.periodSegmented setTitle:[[LocalizationRepeat monthly] lowercaseString] forSegmentAtIndex:0];
	[self.periodSegmented setTitle:[[LocalizationRepeat weekly] lowercaseString] forSegmentAtIndex:1];
	[self.periodSegmented setTitle:[[LocalizationRepeat daily] lowercaseString] forSegmentAtIndex:2];
	[self.periodSegmented setSelectedSegmentIndex:firstNumber < 8 ? 1 : firstNumber < 40 ? 0 : 2];
	[self periodSegmentedValueChanged:self.periodSegmented];
	
	if (self.periodSegmented.selectedSegmentIndex == 0)
		self.monthView.selected = [self.values as:^id(id item) {
			return @(((NSNumber *)item).unsignedIntegerValue - 8);
		}];
	else if (self.periodSegmented.selectedSegmentIndex == 1)
		self.weekView.selected = self.values;
	else
		self.periodStepper.value = firstNumber - 40;
	
	[self periodStepperValueChanged:self.periodStepper];
	
	self.skipLabel.text = [LocalizationRepeat skipRepetition];
/*
	self.doneButton.possibleTitles = [NSSet setWithObjects:[Localization done], [LocalizationPurchase purchase], nil];

	if (self.purchase.purchased) {
		self.doneButton.enabled = YES;
		self.doneButton.title = [Localization done];
	} else {
		self.doneButton.enabled = NO;
		self.doneButton.title = [LocalizationPurchase purchase];
		
		self.skipLabel.enabled = NO;
	}
*/
	self.skipLabel.enabled = self.values ? YES : NO;
	
	if (self.appear)
		return;
		
	self.rateView.image = GLOBAL.statistics.appStore ? [Images starsFull] : [Images starsLine];
	self.rateView.text = [LocalizationRating message];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!self.purchase.purchased) {
		if ([Workflow instance].statistics.beginRepeat > 10 && [Workflow instance].statistics.beginRepeat % GUI_PURCHASE_FREQUENCY == 1)
			[self buy];
//		else
//			self.doneButton.enabled = YES;
	}
	
	if (self.appear)
		return;
	self.appear++;
	
	if (GLOBAL.statistics.appStore)
		return;
	
	__weak RepeatController *__self = self;
	[self.rateView.imageView shake:UIDirectionRight duration:DURATION_M delay:0.0 animation:^{
		__self.rateView.image = [Images starsFull];
	} completion:Nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	self.purchase.productRequestHandler = Nil;
	self.purchase.paymentRequestHandler = Nil;
	
	[[UIApplication sharedApplication] rootViewController].canDisplayBannerAds = NO;
}

- (IBAction)doneButtonTap:(UIBarButtonItem *)sender {
//	if (self.purchase.purchased) {
		self.values = self.periodSegmented.selectedSegmentIndex == 0 ? [self.monthView.selected as:^id(id item) {
				return @(((NSNumber *)item).unsignedIntegerValue + 8);
			}]
			: self.periodSegmented.selectedSegmentIndex == 1 ? self.weekView.selected
			: self.periodSegmented.selectedSegmentIndex == 2 ? self.periodStepper.value == 0 ? Nil
			: @[ @((NSInteger)self.periodStepper.value + 40) ]
			: Nil;
		
		if ([self.popoverDelegate respondsToSelector:@selector(shouldDismissPopover:)])
			[self.popoverDelegate shouldDismissPopover:self];
		else
			[self performSegueWithIdentifier:GUI_SELECT sender:self];
//	} else {
//		[self buy];
//	}
}

- (void)buy {
	self.doneButton.enabled = NO;
	
	NSString *message =[STR_NEW_LINE/*@"• • •\n$description\n• • •\n"*/ stringByAppendingString:[NSString stringWithFormat:[LocalizationPurchase message], @"$price"]];
	__weak RepeatController *__self = self;
	[self presentPurchase:self.purchase title:[LocalizationPurchase title] message:message cancelButtonTitle:[Localization later] purchaseButtonTitle:[LocalizationPurchase purchase] completion:^(BOOL success, NSError *error) {
		if (success) {
			self.doneButton.enabled = YES;
			self.doneButton.title = [Localization done];
			
			self.skipLabel.enabled = self.values ? YES : NO;
		} else {
			self.doneButton.enabled = YES;
		}
		
		[__self presentAlertWithError:error cancelButtonTitle:[Localization cancel]];
		
		__self.canDisplayBannerAds = !success;
		
		if (success)
			[[ADClient sharedClient] addClientToSegment:SEG_PAYED replaceExisting:NO];
	}];
	
	[[ADClient sharedClient] addClientToSegment:SEG_DID_NOT_PAY replaceExisting:NO];
}

- (IBAction)cancelButtonTap:(UIBarButtonItem *)sender {
	if ([self.popoverDelegate respondsToSelector:@selector(shouldDismissPopover:)])
		[self.popoverDelegate shouldDismissPopover:Nil];
	else
		[self performSegueWithIdentifier:GUI_CANCEL sender:self];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake)
		[self performSegueWithIdentifier:GUI_CANCEL sender:self];
}

@end
