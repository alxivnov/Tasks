//
//  CloudStatistics.m
//  Done!
//
//  Created by Alexander Ivanov on 30.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "CloudStatistics.h"
#import "NSArray+Query.h"
#import "NSDate+Calculation.h"
#import "NSHelper.h"
#import "Workflow.h"

#define STATISTICS_KEY @"statistics"
#define DONE_KEY @"done"
#define FIRST_LAUNCH_KEY @"firstLaunch"

@implementation CloudStatistics

+ (NSString *)unique:(NSString *)unique key:(NSString *)key {
	return [NSString stringWithFormat:@"%@.%@", key, unique];
}

+ (NSObject *)objectForKey:(NSString *)key andUnique:(NSString *)unique {
	return [[NSUbiquitousKeyValueStore defaultStore] objectForKey:[self unique:unique key:key]];
}

+ (void)setObject:(NSObject *)object forKey:(NSString *)key andUnique:(NSString *)unique {
	[[NSUbiquitousKeyValueStore defaultStore] setObject:object forKey:[self unique:unique key:key]];
}

- (NSUInteger)cloudDone {
	return [(NSNumber *)[[self class] objectForKey:DONE_KEY andUnique:self.unique] unsignedIntegerValue];;
}

- (void)setCloudDone:(NSUInteger)cloudDone {
	[[self class] setObject:@(cloudDone) forKey:DONE_KEY andUnique:self.unique];
}

- (NSDate *)cloudFirstLaunch {
	return (NSDate *)[[self class] objectForKey:FIRST_LAUNCH_KEY andUnique:self.unique];
}

- (void)setCloudFirstLaunch:(NSDate *)cloudFirstLaunch {
	[[self class] setObject:cloudFirstLaunch forKey:FIRST_LAUNCH_KEY andUnique:self.unique];
}

- (void)save {
	[super save];
	
	if (![Workflow instance].settings.iCloud)
		return;
	
	NSArray *statistics = [[NSUbiquitousKeyValueStore defaultStore] arrayForKey:STATISTICS_KEY];
	if (!statistics)
		statistics = ARRAY(self.unique);
	else if (![statistics any:^BOOL(id item) {
		return [self.unique isEqualToString:item];
	}])
		statistics = [statistics arrayByAddingObject:self.unique];
	else
		statistics = Nil;
	
	if (!statistics)
		return;
	
	[[NSUbiquitousKeyValueStore defaultStore] setArray:statistics forKey:STATISTICS_KEY];

	self.cloudFirstLaunch = self.firstLaunch;
}

- (void)decrementDone {
	BOOL local = ![Workflow instance].settings.iCloud;
	
	NSUInteger done = local ? self.done : self.cloudDone;
	if (done == 0)
		return;
	
	done--;
	if (local)
		self.done = done;
	else
		self.cloudDone = done;
}

- (void)incrementDone {
	BOOL local = ![Workflow instance].settings.iCloud;
	
	NSUInteger done = local ? self.done : self.cloudDone;
	if (done == NSUIntegerMax)
		return;
	
	done++;
	if (local)
		self.done = done;
	else
		self.cloudDone = done;
}

- (NSUInteger)calculateDone {
	if (![Workflow instance].settings.iCloud)
		return self.done;
	
	NSUInteger done = self.cloudDone;
	
	NSArray *statistics = [[NSUbiquitousKeyValueStore defaultStore] arrayForKey:STATISTICS_KEY];
	for (NSString *unique in statistics)
		if (![super.unique isEqualToString:unique])
			done += [(NSNumber *)[[self class] objectForKey:DONE_KEY andUnique:unique] unsignedIntegerValue];
	
	return done;
}

- (NSDate *)calculateFirstLaunch {
	if (![Workflow instance].settings.iCloud)
		return self.firstLaunch;
	
	NSDate *firstLaunch = self.firstLaunch;
	
	NSArray *statistics = [[NSUbiquitousKeyValueStore defaultStore] arrayForKey:STATISTICS_KEY];
	for (NSString *unique in statistics)
		if (![self.unique isEqualToString:unique]) {
			NSDate *date = (NSDate *)[[self class] objectForKey:FIRST_LAUNCH_KEY andUnique:unique];
			if ([date isLessThan:firstLaunch])
				firstLaunch = date;
		}
	
	return firstLaunch;
}

+ (BOOL)isStatisticsKey:(NSString *)key {
	return [key hasPrefix:DONE_KEY] || [key hasPrefix:FIRST_LAUNCH_KEY] || [key isEqualToString:STATISTICS_KEY];
}

@end
