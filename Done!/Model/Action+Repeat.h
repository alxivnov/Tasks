//
//  Action+Repeat.h
//  Done!
//
//  Created by Alexander Ivanov on 15.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action.h"

@interface Action (Repeat)

- (NSDate *)repeatDate;

- (NSString *)repeatDescription;

- (NSString *)repeatDateDescription;

@end
