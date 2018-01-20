//
//  PurchaseStatistics.h
//  Done!
//
//  Created by Alexander Ivanov on 22.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "StatisticsBase.h"

@interface PurchaseStatistics : StatisticsBase

@property (nonatomic, assign) NSUInteger purchaseFolder;
@property (nonatomic, assign) NSUInteger purchaseRepeat;
@property (nonatomic, assign) NSUInteger purchaseLogger;

@property (nonatomic, assign) NSUInteger beginRepeat;
@property (nonatomic, assign) NSUInteger endRepeat;

@property (nonatomic, assign) NSUInteger beginFolder;
@property (nonatomic, assign) NSUInteger endFolder;

@property (nonatomic, assign) NSUInteger beginLogger;
@property (nonatomic, assign) NSUInteger endLogger;

@end
