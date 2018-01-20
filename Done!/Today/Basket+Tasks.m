//
//  Basket+List.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 04.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Task.h"
#import "Basket+Query.h"
#import "Basket+Tasks.h"

@implementation Basket (Tasks)

- (List *)tasks:(NSDate *)date {
	NSRange range = date ? [self rangeWhereDateIsEqualTo:date] : NSMakeRange(0, self.count);
	
	List *list = [[List alloc] initWithKey:Nil];
	for (NSUInteger index = 0; index < range.length; index++) {
		Action *action = [self index:index + range.location];
		Task *task = [action toTask];
		[list.array addObject:task];
	}
	return list;
}

@end
