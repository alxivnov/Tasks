//
//  CustomBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 16.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "CustomBasket.h"
#import "Constants.h"
#import "ColorScheme.h"
#import "Workflow.h"

#import "NSObject+Cast.h"
#import "UIHelper.h"
#import "UIFontCache.h"

#define ROW_HEIGHT 48.0

@interface CustomBasket()
@property (assign, nonatomic) NSInteger reloadTime;

@property (assign, nonatomic, readwrite) NSUInteger count;
@property (assign, nonatomic, readwrite) BOOL isReloading;
@end

@implementation CustomBasket

- (UIView *)background {
	if (!self.tableView.backgroundView)
		self.tableView.backgroundView = [[UIView alloc] init];
	
	return self.tableView.backgroundView;
}

- (UITableViewWithFocus *)table {
	return [self.tableView as:[UITableViewWithFocus class]];
}

- (NSInteger)reloadTime {
	if (!_reloadTime)
		_reloadTime = [[NSDate date] timeIntervalSinceReferenceDate];
	
	return _reloadTime;
}

- (void)willReloadTableView {
	self.isReloading = YES;
}

- (void)reloadTableView:(BOOL)force {
	if (!force && !self.table.isUnfocused)
		return;
	
	NSInteger now = [[NSDate date] timeIntervalSinceReferenceDate];
	if (!force && now == self.reloadTime)
		return;
	
	self.isReloading = YES;
	
	[self.tableView reloadData];
	self.reloadTime = now;
	
	self.isReloading = NO;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.count++;
	
	if (self.count == 1) {
		self.table.minFocusValue = 0;
		self.table.maxFocusValue = FOCUS_VALUE;

		if (IOS_8_0) {
			self.tableView.rowHeight = UITableViewAutomaticDimension;
			self.tableView.estimatedRowHeight = ROW_HEIGHT;
		} else {
			self.tableView.rowHeight = ROW_HEIGHT;
		}
		
		self.tableView.backgroundColor = [ColorScheme instance].whiteColor;
	}
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return [ColorScheme instance].statusBarStyle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GUI_CELL_ID forIndexPath:indexPath];

	if (IOS_8_0)
		cell.textLabel.numberOfLines = GLOBAL.settings.multilineTitles ? 0 : 1;
	
	cell.backgroundColor = [ColorScheme instance].whiteColor;
	cell.textLabel.textColor = [ColorScheme instance].blackColor;
	cell.detailTextLabel.textColor = [ColorScheme instance].blackColor;
	
	cell.textLabel.font = [FNT_CACHE avenirNext:cell.textLabel.font.pointSize];
	cell.detailTextLabel.font = [FNT_CACHE avenirNext:cell.detailTextLabel.font.pointSize];
	
	return cell;
}

- (BOOL)updateColorScheme {
	if (![[ColorScheme instance] update])
		return NO;
	
	self.tableView.backgroundColor = [ColorScheme instance].whiteColor;
	
	[self reloadTableView:YES];
	
	return YES;
}

@end
