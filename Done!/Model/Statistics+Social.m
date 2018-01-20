//
//  Statistics+Social.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 29.01.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "NSDate+Calculation.h"
#import "Statistics+Social.h"

@implementation Statistics (Social)

- (BOOL)monthFromAppStore {
	return !self.appStore || [[self.appStore addValue:1 forComponent:NSCalendarUnitMonth] isPast];
}

- (BOOL)weekFromFirstLaunch {
	return !self.firstLaunch || [[self.firstLaunch addValue:1 forComponent:NSCalendarUnitWeekOfYear] isPast];
}

@end
