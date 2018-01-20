//
//  Action+Period.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 03.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "Action+Period.h"
#import "DateHelper.h"
#import "Localization.h"
#import "NSDate+Calculation.h"

@implementation Action (Period)

- (NSInteger)periodIdentifier {
	NSInteger period = [DateHelper dateIdentifier:self.date];
	
	if ((period == DATE_THIS_WEEK || period == DATE_THIS_MONTH || period == DATE_THIS_YEAR) && [self.date isPast])
		period = 0 - period;
	
	return period;
}

- (NSInteger)period {
	return self.state == GTD_ACTION_STATE_NULL ? PERIOD_IN_BASKET : self.state == GTD_ACTION_STATE_DEFERRAL && !self.date ? PERIOD_SOMEDAY_MAYBE : self.state == GTD_ACTION_STATE_DELEGATE ? PERIOD_DELEGATED : self.state == GTD_ACTION_STATE_DONE ? PERIOD_COMPLETED : [self periodIdentifier];
}

- (NSString *)periodDescription {
	return self.state == GTD_ACTION_STATE_NULL ? [Localization inBasket] : self.state == GTD_ACTION_STATE_DELEGATE ? [Localization delegated] : self.state == GTD_ACTION_STATE_DONE ? [Localization completed] : [DateHelper dateDescription:self.date];
}

@end
