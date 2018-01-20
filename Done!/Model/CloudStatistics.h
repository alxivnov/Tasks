//
//  CloudStatistics.h
//  Done!
//
//  Created by Alexander Ivanov on 30.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Statistics.h"

@interface CloudStatistics : Statistics

@property (assign, nonatomic) NSUInteger cloudDone;
@property (strong, nonatomic) NSDate *cloudFirstLaunch;

- (void)decrementDone;
- (void)incrementDone;

- (NSUInteger)calculateDone;
- (NSDate *)calculateFirstLaunch;

+ (BOOL)isStatisticsKey:(NSString *)key;

@end
