//
//  Workflow.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Workflow.h"
#import "Basket+Activity.h"
#import "Basket+Alert.h"
#import "CloudStatistics.h"
#import "Constants.h"

#import "NSArray+Query.h"
#import "NSCloudKVStoreDataSource.h"
#import "NSHelper.h"
#import "NSString+Alert.h"
#import "NSURL+File.h"
#import "NSLocalFileDataSource.h"
#import "UIApplication+Background.h"

#define LOGGER @"Logger"

@interface Workflow ()
@property (strong, readwrite, nonatomic) Basket *basket;
@property (strong, readwrite, nonatomic) Settings *settings;
@property (strong, readwrite, nonatomic) CloudStatistics *statistics;
@end

@implementation Workflow

static Workflow *_workflow = Nil;

+ (Workflow *)instance {
	@synchronized(self) {
		if (!_workflow)
			_workflow = [self new];
	}
	
    return _workflow;
}

+ (Basket *)logger {
	return [Basket create:LOGGER];
}

// instance

- (Basket *)basket {
	@synchronized(self) {
		if (!_basket) {
			if (self.settings.iCloud) {
				__weak Workflow *__self = self;
				id dataSource = [NSCloudKVStoreDataSource create:^(NSNotification *notification) {
					[__self didChangeExternally:notification];
				}];
				
				_basket = [Basket create:Nil dataSource:dataSource mode:DISTRIBUTED_LAZY];
			} else {
				NSLocalFileDataSource *dataSource = [NSLocalFileDataSource create:APP_GROUP];
				
				NSURL *url = [dataSource urlFromKey:[[Basket class] description]];
				if ([url isExistingFile]) {
					_basket = [Basket create:Nil dataSource:dataSource mode:DISTRIBUTED_LAZY];
				} else {
					_basket = [Basket create:Nil dataSource:Nil mode:DISTRIBUTED];
					_basket.dataSource = dataSource;
					[_basket save];
					
					Basket *basket = [Basket create:Nil dataSource:Nil mode:DISTRIBUTED];
					[basket clear];
					[basket save];
					[[Basket urlFromKey:Nil] removeItem];
				}
				
				NSLog(@"Documents: %@", url);
			}
			
			[NSHelper dispatchToGlobal:^{
				[_basket scheduleNotifications];

				[_basket indexSearchableItems];
			}];
		}
	}
	
    return _basket;
}

- (Settings *)settings {
	@synchronized(self) {
		if (!_settings) {
			NSLocalFileDataSource *dataSource = [NSLocalFileDataSource create:APP_GROUP];
			
			NSURL *url = [dataSource urlFromKey:[[Settings class] description]];
			if ([url isExistingFile]) {
				_settings = [Settings create:Nil dataSource:dataSource];
			} else {
				_settings = [Settings create];
				_settings.dataSource = dataSource;
				[_settings save];
				
				[[Settings urlFromKey:Nil] removeItem];
			}
		}
	}
	
	return _settings;
}

- (CloudStatistics *)statistics {
	@synchronized(self) {
		if (!_statistics) {
			NSLocalFileDataSource *dataSource = [NSLocalFileDataSource create:APP_GROUP];
			
			NSString *key = [[Statistics class] description];
			NSURL *url = [dataSource urlFromKey:key];
			if ([url isExistingFile]) {
				_statistics = [CloudStatistics create:key dataSource:dataSource];
			} else {
				_statistics = [CloudStatistics create:key];
				_statistics.dataSource = dataSource;
				[_statistics save];
				
				[[CloudStatistics urlFromKey:key] removeItem];
			}
		}
	}
	
	return _statistics;
}

- (void)didChangeExternally:(NSNotification *)notification {
	if (!_basket)
		return;

	if ([notification.userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] all:^BOOL(id item) {
		return [CloudStatistics isStatisticsKey:item];
	}])
		return;

	PERFORM_SELECTOR_1(self.delegate, @selector(willChangeExternally:), notification);
	
	[_basket load];
	__block Basket *__basket = _basket;
	[NSHelper dispatchToGlobal:^{
		[__basket scheduleNotifications];

		[__basket indexSearchableItems];
	}];
	
	PERFORM_SELECTOR_1(self.delegate, @selector(didChangeExternally:), notification);
}

- (void)migrate:(BOOL)force {
	if (force) {
		NSCloudKVStoreDataSource *cloud = [NSCloudKVStoreDataSource create];
		NSLocalFileDataSource *local = [NSLocalFileDataSource create:APP_GROUP];
		
		Basket *basket = [Basket create:Nil dataSource:!self.settings.iCloud ? cloud : local mode:DISTRIBUTED];
		[basket clear];
		[basket save];
		
		basket.dataSource = self.settings.iCloud ? cloud : local;
		[basket load];
		
		basket.dataSource = !self.settings.iCloud ? cloud : local;
		[basket save];
		
		if (self.settings.iCloud)
			self.statistics.done = self.statistics.cloudDone;
		else
			self.statistics.cloudDone = self.statistics.done;
	}
	
	self.settings.iCloud = !self.settings.iCloud;
	self.basket = Nil;
}

+ (BOOL)fetch {
	Settings *settings = [Settings create:Nil dataSource:[NSLocalFileDataSource create:APP_GROUP]];
	if (!settings.iCloud)
		return NO;
	
//	[[NSUbiquitousKeyValueStore defaultStore] synchronize];
	
	if (![[UIApplication sharedApplication] isBackground])
		return NO;
	
	__block BOOL changed = NO;
	NSCloudKVStoreDataSource *dataSource = [NSCloudKVStoreDataSource create:^(NSNotification *notification) {
		changed = YES;
	} readonly:YES];
	
	NSTimeInterval interval = 4.0;
	for (; interval > 0.0; interval -= 0.4) {
		if (![[UIApplication sharedApplication] isBackground]) {
			dataSource.externalChangeHandler = Nil;
			return NO;
		}
		
		[NSThread sleepForTimeInterval:0.4];
		
		if (changed)
			break;
	}
	
	dataSource.externalChangeHandler = Nil;

	if (![[UIApplication sharedApplication] isBackground])
		return NO;
	
	Basket *basket = [Basket create:Nil dataSource:dataSource mode:DISTRIBUTED_LAZY];
	[basket scheduleNotifications];
	[basket indexSearchableItems];
	
	return YES;
}

@end
