//
//  GestureBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 04.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LoggerBasket.h"
#import "UIPinchTransition.h"

@interface GestureBasket : LoggerBasket <UIGestureRecognizerDelegate, UIPinchTransitionDelegate>

- (void)pinch:(UIPinchGestureRecognizer *)sender; // abstract

- (void)tap:(UITapGestureRecognizer *)sender; // abstract

@end
