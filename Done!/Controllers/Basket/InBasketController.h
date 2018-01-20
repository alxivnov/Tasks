//
//  InBasketController.h
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Basket.h"
#import "ScrollableBasket.h"

@interface InBasketController : ScrollableBasket <BasketDelegate>

- (void)didReceiveLocalNotification:(UILocalNotification *)notification withAction:(NSString *)identifier;
- (void)openFile:(NSURL *)url;
- (void)significantTimeChange;
- (void)didBecomeActive;
- (void)migrate;

@end
