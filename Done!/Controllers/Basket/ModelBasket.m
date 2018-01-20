//
//  ModelBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 15.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Action+Compare.h"
#import "Action+Process.h"
#import "Basket+Process.h"
#import "Basket+Query.h"
#import "ModelBasket.h"
#import "NSArray+Query.h"
#import "NSHelper.h"
#import "UITableView+Rows.h"
#import "Workflow.h"

@implementation ModelBasket

- (Basket *)basket {
	return _basket ? _basket : [Workflow instance].basket;
}

- (Settings *)settings {
	return _settings ? _settings : [Workflow instance].settings;
}

- (CloudStatistics *)statistics {
	return _statistics ? _statistics : [Workflow instance].statistics;
}

- (NSUInteger)rowForIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row;
}

- (NSIndexPath *)indexPathForRow:(NSUInteger)row {
	return [NSIndexPath indexPathForRow:row inSection:0];
}

- (BOOL)didUpdateModel {
	return NO;	// abstract
}

- (void)sortRowAt:(NSIndexPath *)indexPath {
	NSUInteger row = [self rowForIndexPath:indexPath];
	NSUInteger index = [self.basket sortRowAt:row];
	
	BOOL update = [self didUpdateModel];
	
	if (index == row && !update)
		return;
	
	NSIndexPath *newIndexPath = [self indexPathForRow:index];
	if (newIndexPath)
		[self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
	else
		[self.tableView deleteRowAtIndexPath:indexPath withAnimation:UITableViewRowAnimationAutomatic];
}

- (void)endProcess:(NSIndexPath *)indexPath {
	[self.tableView reloadRowAtIndexPath:indexPath withAnimation:UITableViewRowAnimationAutomatic];
	
	[self sortRowAt:indexPath];
	
	[self.basket save];
}

- (void)done:(NSIndexPath *)indexPath {
	if (self.isReloading)
		return;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	[[self.basket index:row] done];
	
	[self endProcess:indexPath];
}

- (void)undone:(NSIndexPath *)indexPath {
	if (self.isReloading)
		return;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	[[self.basket index:row] undone];
	
	[self endProcess:indexPath];
}

- (void)deferral:(NSIndexPath *)indexPath date:(NSDate *)date {
	if (self.isReloading)
		return;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	[[self.basket index:row] deferral:date];
	
	[self endProcess:indexPath];
}

- (void)calendar:(NSIndexPath *)indexPath date:(NSDate *)date repeat:(NSNumber *)repeat sound:(NSString *)sound alert:(NSNumber *)alert {
	if (self.isReloading)
		return;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	[[self.basket index:row] calendar:date repeat:repeat sound:sound alert:alert];
	
	[self endProcess:indexPath];
}

- (void)delegate:(NSIndexPath *)indexPath owner:(NSInteger)owner ownerDescription:(NSString *)ownerDescription {
	if (self.isReloading)
		return;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	[[self.basket index:row] delegate:owner ownerDescription:ownerDescription];
	
	[self endProcess:indexPath];
}

- (void)add:(NSIndexPath *)indexPath {
	if (self.isReloading)
		return;
	
	Action *action = [[Action alloc] initFromDictionary:Nil];
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	if (![self.basket add:action at:row])
		return;
	
	[self didUpdateModel];
	
	[self.tableView insertRowAtIndexPath:indexPath withAnimation:UITableViewRowAnimationAutomatic];
}

- (void)remove:(NSIndexPath *)indexPath {
	if (self.isReloading)
		return;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	if (![self.basket removeAt:row])
		return;
	
	[self didUpdateModel];
		
	[self.tableView deleteRowAtIndexPath:indexPath withAnimation:UITableViewRowAnimationFade];
	
	[self.basket save];
}

- (void)inBasket:(NSIndexPath *)indexPath {
	if (self.isReloading)
		return;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	[[self.basket index:row] undone];
	
	[self endProcess:indexPath];
}

- (void)clear:(NSArray *)indexPaths {
	if (self.isReloading)
		return;
	
	NSArray *removed = [indexPaths where:^BOOL(id item) {
		return [self.basket removeAt:[self rowForIndexPath:item]];
	}];
	
	if (!removed || !removed.count)
		return;
	
	[self didUpdateModel];
	
	[self.tableView deleteRowsAtIndexPaths:removed withRowAnimation:UITableViewRowAnimationFade];
	
	[self.basket save];
}

- (void)edit:(NSIndexPath *)indexPath title:(NSString *)title sort:(BOOL)sort {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	action.title = title;
	
	[self.tableView reloadRowAtIndexPath:indexPath withAnimation:UITableViewRowAnimationAutomatic];
	
	if (sort)
		[self sortRowAt:indexPath];
	
	[self.basket save];
}

- (void)edit:(NSIndexPath *)indexPath title:(NSString *)title {
	if (self.isReloading)
		return;
	
	[self edit:indexPath title:title sort:NO];
}

- (void)editAndSort:(NSIndexPath *)indexPath title:(NSString *)title {
	if (self.isReloading)
		return;
	
	[self edit:indexPath title:title sort:YES];
}

- (void)order:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
	if (self.isReloading)
		return;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	NSUInteger newRow = [self rowForIndexPath:newIndexPath];
	if (![self.basket moveRowAt:row to:newRow])
		return;
	
//	[self didUpdateModel];
	
	[self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath inReverse:YES];
	
	[self.basket save];
}

- (void)import:(Action *)action {
	if (self.isReloading)
		return;
	
	action.date = action.dateRaw;
	
	NSUInteger index = [self.basket merge:action at:0];
	
	[self didUpdateModel];
	
	if (index == NSNotFound)
		[self.tableView insertRowAtIndexPath:[self indexPathForRow:[self.basket sortRowAt:0]]];
	else
		[self.tableView moveRowAtIndexPath:[self indexPathForRow:index] toIndexPath:[self indexPathForRow:[self.basket sortRowAt:index]]];
	
	[self.basket save];
}

@end
