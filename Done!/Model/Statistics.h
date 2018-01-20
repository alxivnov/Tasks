//
//  Statistics.h
//  Done!
//
//  Created by Alexander Ivanov on 23.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceStatistics.h"

@interface Statistics : InterfaceStatistics

@property (nonatomic, strong, readonly) NSDate *firstLaunch;
@property (nonatomic, assign) NSUInteger launch;

@property (nonatomic, assign) NSUInteger openURL;

@property (nonatomic, assign) NSUInteger beginAdd;
@property (nonatomic, assign) NSUInteger endAdd;
@property (nonatomic, assign) NSUInteger beginPanRemove;
@property (nonatomic, assign) NSUInteger endPanRemove;
@property (nonatomic, assign) NSUInteger tapRemove;
@property (nonatomic, assign) NSUInteger clear;

@property (nonatomic, assign) NSUInteger done;
@property (nonatomic, assign) NSUInteger beginDeferral;
@property (nonatomic, assign) NSUInteger endDeferral;
@property (nonatomic, assign) NSUInteger beginCalendar;
@property (nonatomic, assign) NSUInteger endCalendar;
@property (nonatomic, assign) NSUInteger beginDelegate;
@property (nonatomic, assign) NSUInteger endDelegate;
@property (nonatomic, assign) NSUInteger beginSend;
@property (nonatomic, assign) NSUInteger endSend;

@property (nonatomic, assign) NSUInteger beginEdit;
@property (nonatomic, assign) NSUInteger endEdit;
@property (nonatomic, assign) NSUInteger beginOrder;
@property (nonatomic, assign) NSUInteger endOrder;

@property (nonatomic, assign) NSUInteger settings;

@property (nonatomic, strong) NSDate *upload;

@end
