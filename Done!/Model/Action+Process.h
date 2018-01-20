//
//  Action+Process.h
//  Done!
//
//  Created by Alexander Ivanov on 18.05.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action.h"

@interface Action (Process)

- (void)done;

- (void)deferral:(NSDate *)date;

- (void)calendar:(NSDate *)date repeat:(NSNumber *)repeat sound:(NSString *)sound alert:(NSNumber *)alert;

- (void)delegate:(NSInteger)owner ownerDescription:(NSString *)ownerDescription;

- (void)undone;

- (NSDate *)dateForCalendarController;

@end
