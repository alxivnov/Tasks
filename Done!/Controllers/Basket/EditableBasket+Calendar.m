//
//  EditableBasket+Detector.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 03.04.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "EditableBasket+Calendar.h"
#import "NSDateDetector.h"

@implementation EditableBasket (Calendar)

- (void)editAndCalendar:(NSIndexPath *)indexPath title:(NSString *)title date:(NSDate *)date {
	if (!indexPath)
		indexPath = [self indexPathForRow:0];
	
	if (date) {
		[self edit:indexPath title:title];
		[self calendar:indexPath date:date repeat:Nil sound:Nil alert:Nil];
	} else {
		[self editAndSort:indexPath title:title];
	}
}

- (void)addAndCalendar:(NSIndexPath *)indexPath title:(NSString *)title date:(NSDate *)date {
	if (!indexPath)
		indexPath = [self indexPathForRow:0];
	
	[self add:indexPath];
	
	[self editAndCalendar:indexPath title:title date:date];
}

@end
