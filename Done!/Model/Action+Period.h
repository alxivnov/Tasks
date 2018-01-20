//
//  Action+Period.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 03.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "Action.h"

#define PERIOD_IN_BASKET -30000
#define PERIOD_SOMEDAY_MAYBE 10000
#define PERIOD_DELEGATED 20000
#define PERIOD_COMPLETED 30000

@interface Action (Period)

- (NSInteger)period;

- (NSString *)periodDescription;

@end
