//
//  ControllerBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 08.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "GestureBasket.h"

typedef NS_ENUM(NSInteger, ScrollState) {
	ScrollUpL = -3,
	ScrollUpM = -2,
	ScrollUpS = -1,
	ScrollZero = 0,
	ScrollDownS = 1,
	ScrollDownM = 2,
	ScrollDownL = 3,
};

@interface ControllerBasket : GestureBasket

@property (assign, nonatomic) ScrollState state;

@property (assign, nonatomic) BOOL repeatAdd;

- (void)add;
- (void)clear;

@end
