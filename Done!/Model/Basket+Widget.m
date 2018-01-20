//
//  Basket+Today.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 05.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "AlertHelper.h"
#import "Basket+Alert.h"
#import "Basket+Query.h"
#import "Basket+Widget.h"
#import "Constants.h"

@import NotificationCenter;

@implementation Basket (Widget)

- (void)scheduleWidgetForToday:(NSUInteger)count {
	if (count == NSNotFound)
		count = [self rangeWhereDateIsEqualTo:[AlertHelper today]].length;
	
	[self scheduleBadgeForToday:count];
	
	[[NCWidgetController widgetController] setHasContent:count forWidgetWithBundleIdentifier:APP_WIDGET];
}

@end
