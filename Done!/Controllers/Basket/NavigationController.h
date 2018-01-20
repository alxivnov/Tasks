//
//  NavigationController.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 06.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "BasketController.h"

@interface NavigationController : BasketController

- (void)dismiss:(id <UIPinchTransitionDelegate>)delegate;

@end
