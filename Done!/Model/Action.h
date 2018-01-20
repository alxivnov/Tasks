//
//  Action.h
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Basket.h"
#import "GTDHelper.h"
#import "NSPropertyDictionary.h"

#define FILE_EXTENSION_TASK @".airtask"

@class Basket;

@interface Action : NSPropertyDictionary

@property (weak, nonatomic) Basket *parent;

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) GTD_ACTION_STATE state;
@property (assign, nonatomic) GTD_ACTION_STATE stateRaw;
@property (assign, nonatomic) NSInteger person;
@property (strong, nonatomic) NSString *personDescription;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic, readonly) NSDate *dateRaw;

@property (strong, nonatomic) NSString *soundName;
@property (assign, nonatomic) NSCalendarUnit repeatInterval;
@property (assign, nonatomic) NSTimeInterval alertInterval;

@property (assign, nonatomic, readonly) BOOL folder;
@property (strong, nonatomic) Basket *folderValues;
@property (assign, nonatomic) NSUInteger folderCount;

@property (assign, nonatomic, readonly) BOOL repeat;
@property (strong, nonatomic) NSArray *repeatValues;
@property (assign, nonatomic) NSUInteger repeatCount;

@property (assign, nonatomic) NSUInteger loggerCount;

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSDate *changed;
@property (strong, nonatomic) NSDate *deleted;

@property (strong, nonatomic) NSDate *updated;

- (void)clone:(Action *)action deep:(BOOL)deep;
- (instancetype)clone:(BOOL)deep;

@end
