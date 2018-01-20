//
//  AlertController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 16.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "AlertController.h"
#import "Localization.h"
#import "NSArray+Query.h"
#import "NSDate+Calculation.h"
#import "NSDateComponents+Component.h"
#import "NSIndexPath+Equality.h"
#import "UIHelper.h"
#import "UITableView+Rows.h"
#import "UIViewController+Hierarchy.h"

@interface AlertController ()
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (copy, nonatomic) void(^changed)(NSTimeInterval);
@end

@implementation AlertController

+ (NSString *)alertDisplayName:(NSTimeInterval)alert {
	NSNumber *a = @(alert);
	NSUInteger index = [[self intervalNumbers] firstIndex:^BOOL(id item) {
		return [item isEqualToNumber:a];
	}];
	return index == NSNotFound ? Nil : [self intervalStrings][index];
}

+ (NSTimeInterval)getAlert:(UIViewController *)controller {
	AlertController *vc = VIEW_CONTROLLER(controller);
	
	return [[[self class] intervalNumbers][vc.indexPath.row] doubleValue];
}

+ (void)setAlert:(NSTimeInterval)alert andChanged:(void (^)(NSTimeInterval))changed forViewController:(UIViewController *)controller {
	AlertController *vc = VIEW_CONTROLLER(controller);
	
	NSNumber *a = @(alert);
	NSUInteger index = [[self intervalNumbers] firstIndex:^BOOL(id item) {
		return [item isEqualToNumber:a];
	}];
	if (index != NSNotFound)
		vc.indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	
	vc.changed = changed;
}

static NSArray *_intervalNumbers;

+ (NSArray *)intervalNumbers {
	if (!_intervalNumbers)
		_intervalNumbers = @[ @(0.0),
							  @(5.0 * TIME_MINUTE),
							  @(15.0 * TIME_MINUTE),
							  @(30.0 * TIME_MINUTE),
							  @(1.0 * TIME_HOUR),
							  @(2.0 * TIME_HOUR),
							  @(1.0 * TIME_DAY),
							  @(2.0 * TIME_DAY),
							  @(1.0 * TIME_WEEK) ];
	
	return _intervalNumbers;
}

static NSArray *_intervalStrings;

+ (NSArray *)intervalStrings {
	if (!_intervalStrings) {
		if (IOS_8_0) {
			NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
			formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
			
			_intervalStrings = [self.intervalNumbers as:^id(id item) {
				NSTimeInterval interval = [item doubleValue];
				formatter.allowedUnits = [NSDateComponents mostSignificantComponent:interval];
				return interval >= 1.0 * 60.0 ? [Localization before:[formatter stringFromTimeInterval:interval]] : [Localization atTheSameTime];
			}];
		} else {
			_intervalStrings = @[ @"At the same time", @"5 minutes before", @"15 minutes before", @"30 minutes before", @"1 hour before", @"2 hours before", @"1 day before", @"2 days before", @"1 week before" ];
		}
	}
	
	return _intervalStrings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationItem.title = [Localization alert];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self class] intervalStrings].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellForIndexPath:indexPath];
    
	cell.textLabel.text = [[self class] intervalStrings][indexPath.row];
	
	cell.accessoryType = [indexPath isEqualToIndexPath:self.indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (![indexPath isEqualToIndexPath:self.indexPath]) {
		UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:self.indexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		
		UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		self.indexPath = indexPath;
		
		if (self.changed)
			self.changed([[self class] getAlert:self]);
	}
	
	[tableView deselectRowAtIndexPath:indexPath];
}

@end
