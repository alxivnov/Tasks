//
//  SwipeableBasket.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 02.01.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "PannableBasket.h"

@interface SwipeableBasket : PannableBasket <SwipeableCellDelegate>

- (void)dismissSwipe;

@end
