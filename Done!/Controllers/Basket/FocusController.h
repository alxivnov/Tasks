//
//  FocusBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 09.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ScrollableBasket.h"

@interface FocusController : ScrollableBasket

+ (Basket *)getValues:(UIViewController *)controller;
+ (void)setValues:(Basket *)basket forViewController:(UIViewController *)controller;

@end
