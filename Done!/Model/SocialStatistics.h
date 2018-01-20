//
//  SocialStatistics.h
//  Done!
//
//  Created by Alexander Ivanov on 22.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "PurchaseStatistics.h"

@interface SocialStatistics : PurchaseStatistics

@property (nonatomic, strong) NSDate *compose;
@property (nonatomic, strong) NSDate *appStore;

@property (nonatomic, assign) NSUInteger happy;
@property (nonatomic, assign) NSUInteger confused;
@property (nonatomic, assign) NSUInteger unhappy;

@property (nonatomic, assign) NSUInteger cancel;

@end
