//
//  PurchaseStatistics.m
//  Done!
//
//  Created by Alexander Ivanov on 22.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "PurchaseStatistics.h"
#import "NSObject+Cast.h"

#define PURCHASE_FOLDER @"purchaseFolder"
#define PURCHASE_REPEAT @"purchaseRepeat"
#define PURCHASE_LOGGER @"purchaseLogger"

#define BEGIN_REPEAT_KEY @"beginRepeat"
#define END_REPEAT_KEY @"endRepeat"

#define BEGIN_FOLDER_KEY @"beginFolder"
#define END_FOLDER_KEY @"endFolder"

#define BEGIN_LOGGER_KEY @"beginLogger"
#define END_LOGGER_KEY @"endLogger"

@implementation PurchaseStatistics

- (void)setPurchaseFolder:(NSUInteger)purchaseFolder {
	if (_purchaseFolder == purchaseFolder)
		return;
	
	_purchaseFolder = purchaseFolder;
	[self save];
}

- (void)setPurchaseRepeat:(NSUInteger)purchaseRepeat {
	if (_purchaseRepeat == purchaseRepeat)
		return;
	
	_purchaseRepeat = purchaseRepeat;
	[self save];
}

- (void)setPurchaseLogger:(NSUInteger)purchaseLogger {
	if (_purchaseLogger == purchaseLogger)
		return;
	
	_purchaseLogger = purchaseLogger;
	[self save];
}

- (void)setBeginRepeat:(NSUInteger)repeat {
	if (_beginRepeat == repeat)
		return;
	
	_beginRepeat = repeat;
	[self save];
}

- (void)setEndRepeat:(NSUInteger)repeat {
	if (_endRepeat == repeat)
		return;
	
	_endRepeat = repeat;
	[self save];
}

- (void)setBeginFolder:(NSUInteger)folder {
	if (_beginFolder == folder)
		return;
	
	_beginFolder = folder;
	[self save];
}

- (void)setEndFolder:(NSUInteger)folder {
	if (_endFolder == folder)
		return;
	
	_endFolder = folder;
	[self save];
}

- (void)setBeginLogger:(NSUInteger)logger {
	if (_beginLogger == logger)
		return;
	
	_beginLogger = logger;
	[self save];
}

- (void)setEndLogger:(NSUInteger)logger {
	if (_endLogger == logger)
		return;
	
	_endLogger = logger;
	[self save];
}

- (void)fromDictionary:(NSDictionary *)dictionary {
	[super fromDictionary:dictionary];
	
	if (!dictionary)
		return;
	
	self.purchaseFolder = [((NSNumber *)dictionary[PURCHASE_FOLDER]) unsignedIntegerValue];
	self.purchaseRepeat = [((NSNumber *)dictionary[PURCHASE_REPEAT]) unsignedIntegerValue];
	self.purchaseLogger = [((NSNumber *)dictionary[PURCHASE_LOGGER]) unsignedIntegerValue];
	
	self.beginRepeat = [((NSNumber *)dictionary[BEGIN_REPEAT_KEY]) unsignedIntegerValue];
	self.endRepeat = [((NSNumber *)dictionary[END_REPEAT_KEY]) unsignedIntegerValue];
	
	self.beginFolder = [((NSNumber *)dictionary[BEGIN_FOLDER_KEY]) unsignedIntegerValue];
	self.endFolder = [((NSNumber *)dictionary[END_FOLDER_KEY]) unsignedIntegerValue];
	
	self.beginLogger = [((NSNumber *)dictionary[BEGIN_LOGGER_KEY]) unsignedIntegerValue];
	self.endLogger = [((NSNumber *)dictionary[END_LOGGER_KEY]) unsignedIntegerValue];
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [[super toDictionary] as:[NSMutableDictionary class]];
	
	dictionary[PURCHASE_FOLDER] = @(self.purchaseFolder);
	dictionary[PURCHASE_REPEAT] = @(self.purchaseRepeat);
	dictionary[PURCHASE_LOGGER] = @(self.purchaseLogger);
	
	dictionary[BEGIN_REPEAT_KEY] = @(self.beginRepeat);
	dictionary[END_REPEAT_KEY] = @(self.endRepeat);
	
	dictionary[BEGIN_FOLDER_KEY] = @(self.beginFolder);
	dictionary[END_FOLDER_KEY] = @(self.endFolder);
	
	dictionary[BEGIN_LOGGER_KEY] = @(self.beginLogger);
	dictionary[END_LOGGER_KEY] = @(self.endLogger);
	
	return dictionary;
}

@end
