//
//  StatisticsBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 12.05.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NavigationController.h"
#import "StatisticsView.h"

@interface StatisticsBasket : NavigationController

@property (strong, nonatomic, readonly) StatisticsView *statisticsView;

- (void)hideStatistics;
- (void)showStatistics:(BOOL)show withState:(ScrollState)state;

@end
