//
//  ScrollableBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 16.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "StatisticsBasket.h"

@interface ScrollableBasket : StatisticsBasket

- (void)addWithState:(ScrollState)state;
- (void)clearWithState:(ScrollState)state;

- (void)setImageForState:(ScrollState)state;

- (void)playSoundForState:(ScrollState)state;

@end
