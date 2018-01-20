//
//  StatisticsBase.m
//  Done!
//
//  Created by Alexander Ivanov on 22.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "StatisticsBase.h"

#define UNIQUE_KEY @"unique"

@implementation StatisticsBase

- (NSString *)unique {
	if (!_unique)
		_unique = [NSUUID UUID].UUIDString;
	
	return _unique;
}

- (void)fromDictionary:(NSDictionary *)dictionary {
	if (!dictionary)
		return;
	
	self.unique = (NSString *)dictionary[UNIQUE_KEY];
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	
	dictionary[UNIQUE_KEY] = self.unique;
	
	return dictionary;
}

@end
