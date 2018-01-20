//
//  InterfaceStatistics.m
//  Done!
//
//  Created by Alexander Ivanov on 14.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "InterfaceStatistics.h"
#import "NSObject+Cast.h"

#define REPEATING_ADD_KEY @"repeatingAdd"
#define DISMISS_FOLDER_KEY @"dismissFolder"
#define SHARE_KEY @"share"

@implementation InterfaceStatistics

- (void)setRepeatingAdd:(NSUInteger)repeatingAdd {
	if (_repeatingAdd == repeatingAdd)
		return;
	
	_repeatingAdd = repeatingAdd;
	[self save];
}

- (void)setDismissFolder:(NSUInteger)dismissFolder {
	if (_dismissFolder == dismissFolder)
		return;
	
	_dismissFolder = dismissFolder;
	[self save];
}

- (void)setShare:(NSUInteger)share {
	if (_share == share)
		return;
	
	_share = share;
	[self save];
}

- (void)fromDictionary:(NSDictionary *)dictionary {
	[super fromDictionary:dictionary];
	
	if (!dictionary)
		return;

	self.repeatingAdd = [((NSNumber *)dictionary[REPEATING_ADD_KEY]) unsignedIntegerValue];
	self.dismissFolder = [((NSNumber *)dictionary[DISMISS_FOLDER_KEY]) unsignedIntegerValue];
	self.share = [((NSNumber *)dictionary[SHARE_KEY]) unsignedIntegerValue];
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [[super toDictionary] as:[NSMutableDictionary class]];
	
	dictionary[REPEATING_ADD_KEY] = @(self.repeatingAdd);
	dictionary[DISMISS_FOLDER_KEY] = @(self.dismissFolder);
	dictionary[SHARE_KEY] = @(self.share);
	
	return dictionary;
}

@end
