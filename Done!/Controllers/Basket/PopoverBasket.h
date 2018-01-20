//
//  PopoverBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 21.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "SwipeableBasket.h"
#import "UIPopoverController+Convenience.h"

@interface PopoverBasket : SwipeableBasket <UIPopoverContainerDelegate>

@property (strong, nonatomic) UIPopoverController *popover;

- (void)dismissAll:(BOOL)animated;

+ (BOOL)isPopover:(UIViewController *)controller;

@end
