//
//  Action+Description.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 26.10.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Description.h"
#import "Action+Folder.h"
#import "DateHelper.h"
#import "NSDate+Calculation.h"
#import "NSDate+Description.h"

@implementation Action (Description)

- (NSString *)dateDescription {
	if (self.state == GTD_ACTION_STATE_DEFERRAL)
		return [DateHelper dateDescription:[self.date dateComponent]];
	else if (self.state == GTD_ACTION_STATE_CALENDAR)
		return [self.date descriptionForDateAndTime:NSDateFormatterShortStyle];
	else
		return Nil;
}

- (NSString *)actionDescription {
	NSString *dateDescription = [self dateDescription];
	NSString *folderDescription = [self folderDescription];
	
	return dateDescription ? [NSString stringWithFormat:@"%@ - %@", folderDescription, dateDescription] : folderDescription;
}

@end
