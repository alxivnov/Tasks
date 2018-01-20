//
//  Basket+Alert.h
//  Done!
//
//  Created by Alexander Ivanov on 28.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Basket.h"

@interface Basket (Alert)

- (void)scheduleNotifications;

- (void)scheduleBadgeForToday:(NSUInteger)count;
- (void)scheduleBadgeForTomorrow:(NSUInteger)count;
- (void)scheduleOverdueAlert:(BOOL)updateDate;
- (void)scheduleProcessAlert:(BOOL)updateDate;
- (void)scheduleReviewAlert;

@end
