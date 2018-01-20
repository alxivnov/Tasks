//
//  Basket+Period.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 03.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "Basket.h"

@interface Basket (Period)

- (NSRange)rangeWherePeriodIsEqualTo:(NSInteger)period;

- (NSUInteger)indexWherePeriodIsCloseTo:(NSInteger)period;

@end
