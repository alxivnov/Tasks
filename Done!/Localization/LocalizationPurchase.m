//
//  LocalizationPurchase.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 06.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LocalizationPurchase.h"

@implementation LocalizationPurchase

+ (NSString *)purchase {
	return NSLocalizedString(@"Purchase", Nil);
}

+ (NSString *)try {
	return NSLocalizedString(@"Try for a week", Nil);
}

+ (NSString *)expired {
	return NSLocalizedString(@"Receipt for this app expired.", Nil);
}

+ (NSString *)title {
	return NSLocalizedString(@"Premium Feature", Nil);
}

+ (NSString *)message {
	return NSLocalizedString(@"Disable ads here just for %@ right now!", Nil);
}

+ (NSString *)disabled {
	return NSLocalizedString(@"This is a premium feature. But you disabled in-app purchases. Enable them in settings to proceed.", Nil);
}

+ (NSString *)failed {
	return NSLocalizedString(@"Purchase transaction for the feature failed. Try again later.", Nil);
}

+ (NSString *)error {
	return NSLocalizedString(@"This is a premium feature. But your device does not have internet connection now. Try again later.", Nil);
}

+ (NSString *)restored {
	return NSLocalizedString(@"All previously purchased features were restored.", Nil);
}

@end
