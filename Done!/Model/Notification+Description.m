//
//  ReminderSettings+Interface.m
//  Done!
//
//  Created by Alexander Ivanov on 25.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Localization.h"
#import "NSDate+Calculation.h"
#import "NSDate+Description.h"
#import "Notification+Description.h"

@implementation Notification (Description)

- (NSString *)timeDescription {
	return self.on ? [[[[NSDate date] dateComponent] move:self.time] descriptionForTime:NSDateFormatterShortStyle] : [Localization disabled];
}

@end
