//
//  Workflow.h
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Basket.h"
#import "Settings.h"
#import "CloudStatistics.h"

#define GLOBAL [Workflow instance]

@interface Workflow : NSObject

+ (Workflow *) instance;

+ (Basket *)logger;

// instance

@property (strong, readonly, nonatomic) Basket *basket;

@property (strong, readonly, nonatomic) Settings *settings;

@property (strong, readonly, nonatomic) CloudStatistics *statistics;

@property (assign, nonatomic) id <BasketDelegate> delegate;

- (void)migrate:(BOOL)force;

+ (BOOL)fetch;

@end
