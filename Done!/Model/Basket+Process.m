//
//  Basket+Process.m
//  Done!
//
//  Created by Alexander Ivanov on 07.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Compare.h"
#import "Basket+Process.h"
#import "Basket+Query.h"
#import "NSDate+Calculation.h"

@implementation Basket (Process)

- (BOOL)moveRowAt:(NSUInteger)index to:(NSUInteger)newIndex {
	if (index == newIndex)
		return NO;
	
	Action *action = [self index:index];
	
	return action && [self removeAt:index] && [self add:action at:newIndex];
}

- (NSUInteger)siteRowAt:(NSUInteger)index {
	Action *action = [self index:index];
	
	NSUInteger newIndex;
	for (newIndex = 0; newIndex < [self count]; newIndex++)
		if (newIndex != index) {
			Action *temp = [self index:newIndex];
			if ([action compare:temp] == NSOrderedAscending)
				break;
		}
	if (index < newIndex)
		newIndex -= 1;
	
	return newIndex;
}

- (NSUInteger)sortRowAt:(NSUInteger)index {
	NSUInteger newIndex = [self siteRowAt:index];
	
	return [self moveRowAt:index to:newIndex] ? newIndex : index;
}

- (NSUInteger)merge:(Action *)action at:(NSUInteger)index {
	NSUInteger oldIndex = [self indexWhereUuidIsEqualTo:action.uuid];
	
	if (oldIndex != NSNotFound) {
		Action *oldAction = [self index:oldIndex];
		if ([oldAction.changed isGreaterThan:action.changed])
			[action clone:oldAction deep:NO];
		
		if (oldAction.folder)
			for (NSInteger index = [oldAction.folderValues count] - 1; index >= 0; index--) {
				Action *oldSub = [oldAction.folderValues index:index];

				Action *sub = [action.folderValues index:[action.folderValues indexWhereUuidIsEqualTo:oldSub.uuid]];
				if (sub) {
					if ([oldSub.changed isGreaterThan:sub.changed])
						[sub clone:oldSub deep:YES];
				} else {
					if ([action.folderValues add:oldSub at:0])
						[action.folderValues sortRowAt:0];
					
					[oldAction.folderValues removeAt:index];
				//	sub.changed = [NSDate date];
				}
			}
		
		[self removeAt:oldIndex];
		
		index = oldIndex;
	}
	
	[self add:action at:index];
	
	return oldIndex;
}

@end
