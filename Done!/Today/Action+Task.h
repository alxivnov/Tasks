//
//  Action+Task.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 04.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action.h"
#import "Task.h"

@interface Action (Task)

- (Task *)toTask;

@end
