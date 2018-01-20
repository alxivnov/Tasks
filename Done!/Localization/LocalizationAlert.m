//
//  LocalizationAlert.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 01.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LocalizationAlert.h"

@implementation LocalizationAlert

+ (NSString *)actionComplete {
	return NSLocalizedString(@"Complete", Nil);
}

+ (NSString *)actionPostpone {
	return NSLocalizedString(@"Postpone", Nil);
}

+ (NSString *)bodyOverdue {
	return NSLocalizedString(@"You have uncompleted tasks (%@). Complete them or assign them new dates.", Nil);
}

+ (NSString *)bodyProcess {
	return NSLocalizedString(@"You should process collected tasks (%@) regularly to stay organized.", Nil);
}

+ (NSString *)bodyReview {
	return NSLocalizedString(@"Review your list (%@) every week, this will keep it current and reliable.", Nil);
}

@end
