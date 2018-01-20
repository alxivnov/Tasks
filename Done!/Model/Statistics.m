//
//  Statistics.m
//  Done!
//
//  Created by Alexander Ivanov on 23.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Statistics.h"

#import "NSFileManager+Convenience.h"
#import "NSHelper.h"
#import "NSObject+Cast.h"
#import "NSURL+File.h"

#define FIRST_LAUNCH_KEY @"firstLaunch"
#define LAUNCH_KEY @"launch"

#define OPEN_URL @"openURL"

#define BEGIN_ADD_KEY @"beginAdd"
#define END_ADD_KEY @"endAdd"
#define BEGIN_PAN_REMOVE_KEY @"beginPanRemove"
#define END_PAN_REMOVE_KEY @"endPanRemove"
#define TAP_REMOVE_KEY @"tapRemove"
#define CLEAR_KEY @"clear"

#define	DONE_KEY @"done"
#define BEGIN_DEFERRAL_KEY @"beginDeferral"
#define END_DEFERRAL_KEY @"endDeferral"
#define BEGIN_CALENDAR_KEY @"beginCalendar"
#define END_CALENDAR_KEY @"endCalendar"
#define BEGIN_DELEGATE_KEY @"beginDelegate"
#define END_DELEGATE_KEY @"endDelegate"
#define BEGIN_SEND_KEY @"beginSend"
#define END_SEND_KEY @"endSend"

#define BEGIN_EDIT_KEY @"beginEdit"
#define END_EDIT_KEY @"endEdit"
#define BEGIN_ORDER_KEY @"beginOrder"
#define END_ORDER_KEY @"endOrder"

#define SETTINGS_KEY @"settings"

#define UPLOAD_KEY @"upload"

@interface Statistics ()
@property (strong, nonatomic, readwrite) NSDate *firstLaunch;
@end

@implementation Statistics

- (NSDate *)firstLaunch {
	if (!_firstLaunch)
		_firstLaunch = [NSDate date];
	
	return _firstLaunch;
}

- (void)setLaunch:(NSUInteger)launch {
	if (_launch == launch)
		return;
	
	_launch = launch;
	[self save];
}

- (void)setOpenURL:(NSUInteger)openURL {
	if (_openURL == openURL)
		return;
	
	_openURL = openURL;
	[self save];
}

- (void)setBeginAdd:(NSUInteger)add {
	if (_beginAdd == add)
		return;
	
	_beginAdd = add;
	[self save];
}

- (void)setEndAdd:(NSUInteger)add {
	if (_endAdd == add)
		return;
	
	_endAdd = add;
	[self save];
}

- (void)setBeginPanRemove:(NSUInteger)remove {
	if (_beginPanRemove == remove)
		return;
	
	_beginPanRemove = remove;
	[self save];
}

- (void)setEndPanRemove:(NSUInteger)remove {
	if (_endPanRemove == remove)
		return;
	
	_endPanRemove = remove;
	[self save];
}

- (void)setTapRemove:(NSUInteger)remove {
	if (_tapRemove == remove)
		return;
	
	_tapRemove = remove;
	[self save];
}

- (void)setClear:(NSUInteger)clear {
	if (_clear == clear)
		return;
	
	_clear = clear;
	[self save];
}

- (void)setDone:(NSUInteger)done {
	if (_done == done)
		return;
	
	_done = done;
	[self save];
}

- (void)setBeginDeferral:(NSUInteger)deferral {
	if (_beginDeferral == deferral)
		return;
	
	_beginDeferral = deferral;
	[self save];
}

- (void)setEndDeferral:(NSUInteger)deferral {
	if (_endDeferral == deferral)
		return;
	
	_endDeferral = deferral;
	[self save];
}

- (void)setBeginCalendar:(NSUInteger)calendar {
	if (_beginCalendar == calendar)
		return;
	
	_beginCalendar = calendar;
	[self save];
}

- (void)setEndCalendar:(NSUInteger)calendar {
	if (_endCalendar == calendar)
		return;
	
	_endCalendar = calendar;
	[self save];
}

- (void)setBeginDelegate:(NSUInteger)delegate {
	if (_beginDelegate == delegate)
		return;
	
	_beginDelegate = delegate;
	[self save];
}

- (void)setEndDelegate:(NSUInteger)delegate {
	if (_endDelegate == delegate)
		return;
	
	_endDelegate = delegate;
	[self save];
}

- (void)setBeginSend:(NSUInteger)send {
	if (_beginSend == send)
		return;
	
	_beginSend = send;
	[self save];
}

- (void)setEndSend:(NSUInteger)send {
	if (_endSend == send)
		return;
	
	_endSend = send;
	[self save];
}

- (void)setBeginEdit:(NSUInteger)edit {
	if (_beginEdit == edit)
		return;
	
	_beginEdit = edit;
	[self save];
}

- (void)setEndEdit:(NSUInteger)edit {
	if (_endEdit == edit)
		return;
	
	_endEdit = edit;
	[self save];
}

- (void)setBeginOrder:(NSUInteger)order {
	if (_beginOrder == order)
		return;
	
	_beginOrder = order;
	[self save];
}

- (void)setEndOrder:(NSUInteger)order {
	if (_endOrder == order)
		return;
	
	_endOrder = order;
	[self save];
}

- (void)setSettings:(NSUInteger)value {
	if (_settings == value)
		return;
	
	_settings = value;
	[self save];
}

@synthesize upload = _upload;

- (NSDate *)upload {
	if (!_upload)
		_upload = [NSDate date];
	
	return _upload;
}

- (void)setUpload:(NSDate *)upload {
	if ([_upload isEqualToDate:upload])
		return;
	
	_upload = upload;
	[self save];
}

- (void)fromDictionary:(NSDictionary *)dictionary {
	[super fromDictionary:dictionary];
	
	if (!dictionary)
		return;
	
	NSDate *firstLaunch = dictionary[FIRST_LAUNCH_KEY];
	self.firstLaunch = firstLaunch ? firstLaunch : [[NSFileManager URLForDirectory:NSDocumentDirectory] fileCreationDate];
	self.launch = [((NSNumber *)dictionary[LAUNCH_KEY]) unsignedIntegerValue];
	
	self.openURL = [((NSNumber *)dictionary[OPEN_URL]) unsignedIntegerValue];
	
	self.beginAdd = [((NSNumber *)dictionary[BEGIN_ADD_KEY]) unsignedIntegerValue];
	self.endAdd = [((NSNumber *)dictionary[END_ADD_KEY]) unsignedIntegerValue];
	self.beginPanRemove = [((NSNumber *)dictionary[BEGIN_PAN_REMOVE_KEY]) unsignedIntegerValue];
	self.endPanRemove = [((NSNumber *)dictionary[END_PAN_REMOVE_KEY]) unsignedIntegerValue];
	self.tapRemove = [((NSNumber *)dictionary[TAP_REMOVE_KEY]) unsignedIntegerValue];
	self.clear = [((NSNumber *)dictionary[CLEAR_KEY]) unsignedIntegerValue];
	
	self.done = [((NSNumber *)dictionary[DONE_KEY]) unsignedIntegerValue];
	self.beginDeferral = [((NSNumber *)dictionary[BEGIN_DEFERRAL_KEY]) unsignedIntegerValue];
	self.endDeferral = [((NSNumber *)dictionary[END_DEFERRAL_KEY]) unsignedIntegerValue];
	self.beginCalendar = [((NSNumber *)dictionary[BEGIN_CALENDAR_KEY]) unsignedIntegerValue];
	self.endCalendar = [((NSNumber *)dictionary[END_CALENDAR_KEY]) unsignedIntegerValue];
	self.beginDelegate = [((NSNumber *)dictionary[BEGIN_DELEGATE_KEY]) unsignedIntegerValue];
	self.endDelegate = [((NSNumber *)dictionary[END_DELEGATE_KEY]) unsignedIntegerValue];
	self.beginSend = [((NSNumber *)dictionary[BEGIN_SEND_KEY]) unsignedIntegerValue];
	self.endSend = [((NSNumber *)dictionary[END_SEND_KEY]) unsignedIntegerValue];
	
	self.beginEdit = [((NSNumber *)dictionary[BEGIN_EDIT_KEY]) unsignedIntegerValue];
	self.endEdit = [((NSNumber *)dictionary[END_EDIT_KEY]) unsignedIntegerValue];
	self.beginOrder = [((NSNumber *)dictionary[BEGIN_ORDER_KEY]) unsignedIntegerValue];
	self.endOrder = [((NSNumber *)dictionary[END_ORDER_KEY]) unsignedIntegerValue];
	
	self.settings = [((NSNumber *)dictionary[SETTINGS_KEY]) unsignedIntegerValue];
	
	self.upload = (NSDate *)dictionary[UPLOAD_KEY];
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [[super toDictionary] as:[NSMutableDictionary class]];
	
	dictionary[FIRST_LAUNCH_KEY] = self.firstLaunch;
	dictionary[LAUNCH_KEY] = @(self.launch);
	
	dictionary[OPEN_URL] = @(self.openURL);
	
	dictionary[BEGIN_ADD_KEY] = @(self.beginAdd);
	dictionary[END_ADD_KEY] = @(self.endAdd);
	dictionary[BEGIN_PAN_REMOVE_KEY] = @(self.beginPanRemove);
	dictionary[END_PAN_REMOVE_KEY] = @(self.endPanRemove);
	dictionary[TAP_REMOVE_KEY] = @(self.tapRemove);
	dictionary[CLEAR_KEY] = @(self.clear);
	
	dictionary[DONE_KEY] = @(self.done);
	dictionary[BEGIN_DEFERRAL_KEY] = @(self.beginDeferral);
	dictionary[END_DEFERRAL_KEY] = @(self.endDeferral);
	dictionary[BEGIN_CALENDAR_KEY] = @(self.beginCalendar);
	dictionary[END_CALENDAR_KEY] = @(self.endCalendar);
	dictionary[BEGIN_DELEGATE_KEY] = @(self.beginDelegate);
	dictionary[END_DELEGATE_KEY] = @(self.endDelegate);
	dictionary[BEGIN_SEND_KEY] = @(self.beginSend);
	dictionary[END_SEND_KEY] = @(self.endSend);
	
	dictionary[BEGIN_EDIT_KEY] = @(self.beginEdit);
	dictionary[END_EDIT_KEY] = @(self.endEdit);
	dictionary[BEGIN_ORDER_KEY] = @(self.beginOrder);
	dictionary[END_ORDER_KEY] = @(self.endOrder);
	
	dictionary[SETTINGS_KEY] = @(self.settings);
	
	if (self.upload)
		dictionary[UPLOAD_KEY] = self.upload;
	
	return dictionary;
}

@end
