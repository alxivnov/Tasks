//
//  List.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 04.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "List.h"
#import "Task.h"

@implementation List

- (NSPropertyDictionary *)createItem {
	return [[Task alloc] init];
}

@end
