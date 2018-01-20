//
//  Basket+Notification.h
//  Done!
//
//  Created by Alexander Ivanov on 14.12.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Basket.h"

@interface Basket (Query)

- (NSRange)rangeWhereDateIsEqualTo:(NSDate *)date;
- (NSRange)rangeWhereDateIsGreaterThan:(NSDate *)date;
- (NSRange)rangeWhereDateIsLessThan:(NSDate *)date;

- (NSRange)rangeWhereStateIsEqualToZero;

- (NSUInteger)indexWhereUuidIsEqualTo:(NSString *)uuid;

- (NSArray *)indexesWhereStateIsEqualToDone;

@end
