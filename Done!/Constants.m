//
//  Constants.m
//  Done!
//
//  Created by Alexander Ivanov on 04.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Constants.h"

#define APP_BUNDLE_IDENTIFIER @"com.alexivanov.done"
#define IN_APP_PURCHASE_FOLDER @"projects"
#define IN_APP_PURCHASE_REPEAT @"periodic"
#define IN_APP_PURCHASE_LOGGER @"archives"

@implementation Constants

static NSDate *_dateTime;

+ (void)updateDateTime {
	_dateTime = [NSDate date];
}

+ (NSTimeInterval)dateTime {
	return [_dateTime timeIntervalSinceNow];
}

+ (NSString *)appBundleIdentifier {
	return APP_BUNDLE_IDENTIFIER;
}

+ (NSString *)inAppPurchase:(NSString *)identifier {
	return [NSString stringWithFormat:@"%@.%@", APP_BUNDLE_IDENTIFIER, identifier];
}

+ (NSString *)inAppPurchaseFolder {
	return [self inAppPurchase:IN_APP_PURCHASE_FOLDER];
}

+ (NSString *)inAppPurchaseRepeat {
	return [self inAppPurchase:IN_APP_PURCHASE_REPEAT];
}

+ (NSString *)inAppPurchaseLogger {
	return [self inAppPurchase:IN_APP_PURCHASE_LOGGER];
}

@end