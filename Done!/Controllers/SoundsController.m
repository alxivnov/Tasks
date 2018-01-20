//
//  ReminderController.m
//  Done!
//
//  Created by Alexander Ivanov on 13.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ASHelper.h"
#import "Constants.h"
#import "Localization.h"
#import "NSIndexPath+Equality.h"
#import "NSObject+Cast.h"
#import "SoundsController.h"
#import "Sounds.h"
#import "UIViewController+Hierarchy.h"

#define CELL_ID @"sound"

@interface SoundsController ()
@property (strong, nonatomic) NSArray *sounds;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (copy, nonatomic) void (^changed)(NSString *sound);
@end

@implementation SoundsController

+ (NSString *)soundDisplayName:(NSString *)path {
	return [[[[path lastPathComponent] stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"-" withString:@" "] capitalizedString];
}

+ (NSString *)getSound:(UIViewController *)controller {
	SoundsController *vc = VIEW_CONTROLLER(controller);
	
	return [vc.sounds[vc.indexPath.row] lastPathComponent];
}

+ (void)setSound:(NSString *)sound andChanged:(void(^)(NSString *sound))changed forViewController:(UIViewController *)controller {
	SoundsController *vc = VIEW_CONTROLLER(controller);

	NSUInteger count = [vc.sounds count];
	for (NSUInteger index = 0; index < count; index++)
		if ([[vc.sounds[index] lastPathComponent] isEqualToString:sound]) {
			vc.indexPath = [NSIndexPath indexPathForRow:index inSection:0];
			break;
		}
	
	vc.changed = changed;
}

- (NSArray *)sounds {
	if (!_sounds)
		_sounds = [[NSBundle mainBundle] pathsForResourcesOfType:AIFF inDirectory:Nil];
	
	return _sounds;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];

	NSString *sound = self.sounds[indexPath.row];
	
	cell.textLabel.text = [[self class] soundDisplayName:sound];
    
	cell.accessoryType = [indexPath isEqualToIndexPath:self.indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.sounds count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (![indexPath isEqualToIndexPath:self.indexPath]) {
		UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:self.indexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		
		UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		self.indexPath = indexPath;
		
		if (self.changed)
			self.changed([[self class] getSound:self]);
	}
	
	[ASHelper stopAll];
	[ASHelper play:[NSURL fileURLWithPath:self.sounds[indexPath.row]]];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = [Localization sound];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[ASHelper stopAll];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake)
		[self.navigationController popViewControllerAnimated:YES];
}

@end
