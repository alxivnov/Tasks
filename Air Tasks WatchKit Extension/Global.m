//
//  Workflow.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 01.04.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "Global.h"

@interface Global ()
@property (strong, nonatomic) List *list;
@end

@implementation Global

static id _instance = Nil;

+ (instancetype)instance {
	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}
	
	return _instance;
}

- (void)setListFromArray:(NSArray *)array {
	self.list = [[List alloc] initFromArray:array];
}

@end
