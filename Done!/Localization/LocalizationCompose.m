//
//  LocalizationCompose.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 06.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LocalizationCompose.h"

@implementation LocalizationCompose

+ (NSString *)happy {
	return NSLocalizedString(@"Happy", Nil);
}

+ (NSString *)confused {
	return NSLocalizedString(@"Confused", Nil);
}

+ (NSString *)unhappy {
	return NSLocalizedString(@"Unhappy", Nil);
}

+ (NSString *)happyTitle {
	return NSLocalizedString(@"Tell the story of your success and help others to achive the same!", Nil);
}

+ (NSString *)confusedTitle {
	return NSLocalizedString(@"Search for help on a website or write an email to developer.", Nil);
}

+ (NSString *)unhappyTitle {
	return NSLocalizedString(@"Sorry to hear. What can I do to fix this?", Nil);
}

+ (NSString *)message {
	return NSLocalizedString(@"How do you feel about it?", Nil);
}

+ (NSString *)text {
	return NSLocalizedString(@"I completed %@ tasks!", Nil);
}

@end
