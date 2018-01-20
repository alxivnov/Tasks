//
//  PostponeController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 17.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "Constants.h"
#import "DateHelper.h"
#import "Images.h"
#import "Localization.h"
#import "LocalizationRating.h"
#import "NSHelper.h"
#import "NSIndexPath+Equality.h"
#import "NSObject+Cast.h"
#import "Palette.h"
#import "PostponeController.h"
#import "RateView.h"
#import "SocialHelper.h"
#import "Statistics+Social.h"
#import "UIApplication+ViewController.h"
#import "UIColor+Mixer.h"
#import "UIScrollView+Scroll.h"
#import "UITableView+Rows.h"
#import "UIView+Animation.h"
#import "UIViewController+Hierarchy.h"
#import "Workflow.h"

@interface PostponeController ()
@property (strong, nonatomic) NSArray *dates;

@property (strong, nonatomic) NSDate *date;

@property (assign, nonatomic) NSUInteger appear;
@end

@implementation PostponeController

+ (NSDate *)getDate:(UIViewController *)controller {
	return [PostponeController viewController:controller].date;
}

- (NSArray *)dates {
	if (!_dates) {
		NSArray *dates = [DateHelper deferralDates];
		dates = [dates arrayByAddingObjectsFromArray:@[ [NSObject new], [Localization someday] ] ];
		_dates = dates;
	}
	
	return _dates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self.tableView setContentInsetTop:self.tableView.contentInset.top + self.navigationController.navigationBar.frame.size.height];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.appear)
		return;
	self.appear++;
	
	if (GLOBAL.statistics.appStore)
		return;
	
	RateView *rateView = [self.tableView cellForRow:0 inSection:1].contentView.subviews.firstObject;
	[rateView.imageView shake:UIDirectionRight duration:DURATION_M delay:0.0 animation:^{
		rateView.image = [Images starsFull];
	} completion:Nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	Statistics *statistics = GLOBAL.statistics;
	return !([statistics weekFromFirstLaunch] && [statistics monthFromAppStore]) && !IS_DEBUGGING ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section ? 1 : self.dates.count / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = Nil;
	
	if (indexPath.section) {
		cell = [tableView dequeueCustomCellForIndexPath:indexPath];
		
		RateView *rateView = cell.contentView.subviews.firstObject;
		rateView.image = GLOBAL.statistics.appStore ? [Images starsFull] : [Images starsLine];
		rateView.text = [LocalizationRating message];
	} else {
		cell = [tableView dequeueBasicCellForIndexPath:indexPath];
		
		cell.textLabel.text = self.dates[indexPath.row * 2 + 1];
		
		cell.imageView.image = [Images deferralLine];
		cell.imageView.highlightedImage = [Images deferralFull];
		cell.imageView.tintColor = [[Palette yellow] mixWithColor:[Palette lightGray] value:(double)indexPath.row / (self.dates.count / 2 - 1)];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section) {
		RateView *rateView = [tableView cellForRowAtIndexPath:indexPath].contentView.subviews.firstObject;
		[rateView open:URL_APP_STORE withDuration:0];
		
		GLOBAL.statistics.appStore = [NSDate date];
	} else {
		self.date = [self.dates[indexPath.row * 2] as:[NSDate class]];
		
		__weak PostponeController *__self = self;
		if (self.completion)
			self.completion(__self, YES);
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section ? @"APP STORE" : [super tableView:tableView titleForHeaderInSection:section];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([UIHelper iPhone:self] && scrollView.isDragging && scrollView.contentOffset.y < scrollView.bounds.size.height / -3.0) {
		__weak PostponeController *__self = self;
		if (self.completion)
			self.completion(__self, NO);
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
