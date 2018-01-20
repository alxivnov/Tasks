//
//  Task.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 04.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "GTDHelper.h"
#import "NSPropertyDictionary.h"

@import UIKit;

@interface Task : NSPropertyDictionary

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSUInteger titleLength;
@property (assign, nonatomic) GTD_ACTION_STATE state;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dateDescription;
@property (strong, nonatomic) NSString *uuid;

- (NSAttributedString *)attributedTitle:(UIFont *)font;

@end
