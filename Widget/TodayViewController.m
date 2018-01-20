//
//  TodayViewController.m
//  Widget
//
//  Created by Alexander Ivanov on 04.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <NotificationCenter/NotificationCenter.h>

#import "Basket.h"
#import "Basket+Query.h"
#import "Constants.h"
#import "NSArray+Query.h"
#import "NSDate+Calculation.h"
#import "NSCloudKVStoreDataSource.h"
#import "NSURL+Parse.h"
#import "NSLocalFileDataSource.h"
#import "Settings.h"
#import "TodayViewController.h"
#import "UITableViewCell+Task.h"

#define CELL @"subtitle"

@import Foundation;

@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) Settings *settings;

@property (strong, nonatomic) Basket *basket;

@property (assign, nonatomic) NSRange range;
@end

@implementation TodayViewController

- (Settings *)settings {
	if (!_settings)
		_settings = [Settings create:Nil dataSource:[NSLocalFileDataSource create:APP_GROUP]];
	
	return _settings;
}

- (Basket *)basket {
	if (!_basket) {
		__weak TodayViewController *__self = self;
		id dataSource = self.settings.iCloud ? [NSCloudKVStoreDataSource create:^(NSNotification *notification) {
			[__self didChangeExternally:notification];
		} readonly:YES] : [NSLocalFileDataSource create:APP_GROUP];
		
		_basket = [Basket create:Nil dataSource:dataSource mode:DISTRIBUTED_LAZY];

		self.range = [_basket rangeWhereDateIsEqualTo:[[NSDate date] dateComponent]];
	}
	
	return _basket;
}

- (void)didChangeExternally:(NSNotification *)notification {
	((NSCloudKVStoreDataSource *)_basket.dataSource).externalChangeHandler = Nil;
	
	[_basket load];
	
	[self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL forIndexPath:indexPath];
	
	Action *action = [self.basket index:indexPath.row + self.range.location];
	[cell setup:action];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.basket ? self.range.length : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
	
	Action *task = [self.basket index:indexPath.row + self.range.location];
	NSURL *url = [NSURL urlWithScheme:URL_SCHEME andParameters:@{ URL_PARAMETER_UUID : task.uuid }];
	[[self extensionContext] openURL:url completionHandler:Nil];
}

- (void)updatePreferredContentSize {
	CGSize size = self.preferredContentSize;
	
	size.height = self.tableView.contentSize.height;
	
	[self setPreferredContentSize:size];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self updatePreferredContentSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	
	self.basket = Nil;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encoutered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
	
	self.basket = Nil;
	
	[self updatePreferredContentSize];

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
	defaultMarginInsets.left = 0.0;
	defaultMarginInsets.bottom = 0.0;
	
	return defaultMarginInsets;
}

@end
