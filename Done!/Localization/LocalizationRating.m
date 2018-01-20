//
//  LocalizationRating.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 26.12.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LocalizationRating.h"

#import "NSBundle+Convenience.h"

@implementation LocalizationRating

+ (NSString *)title:(NSUInteger)count {
	return [NSString stringWithFormat:NSLocalizedString(@"Congratulations! You completed %@ tasks.", Nil), @(count)];
}

+ (NSString *)message {
	return NSLocalizedString(@"Please, rate this app on the App Store. Thanks!", Nil);
}

+ (NSString *)now:(NSString *)name {
	return [NSString stringWithFormat:NSLocalizedString(@"Rate %@", Nil), name.length ? name : [NSBundle bundleDisplayName]];
}

+ (NSString *)later {
	return NSLocalizedString(@"Not now", Nil);
}

+ (NSString *)never {
	return NSLocalizedString(@"Don't ask again", Nil);
}

@end
