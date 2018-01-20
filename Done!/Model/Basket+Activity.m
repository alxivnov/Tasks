//
//  Basket+Activity.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 02/12/15.
//  Copyright © 2015 Alex Ivanov. All rights reserved.
//

#import "Basket+Activity.h"
#import "Action+Activity.h"

#import "NSArray+Query.h"

@implementation Basket (Activity)

- (void)indexSearchableItems {
	NSMutableArray *items = [NSMutableArray new];
	for (NSUInteger index = 0; index < [self count]; index++) {
		CSSearchableItem *item = [[self index:index] searchableItem];
		if (item)
			[items addObject:item];
	}

	[[CSSearchableIndex defaultSearchableIndex] reindexAllSearchableItems:items];
}

@end
