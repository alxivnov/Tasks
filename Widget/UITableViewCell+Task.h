//
//  UITableViewCell+Task.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 05.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Action.h"

@interface UITableViewCell (Task)

- (void)setup:(Action *)task;

@end
