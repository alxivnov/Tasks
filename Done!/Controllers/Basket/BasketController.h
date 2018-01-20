//
//  BasketController.h
//  Done!
//
//  Created by Alexander Ivanov on 03.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "PopoverBasket.h"
#import "SKReceiptObserver.h"

@interface BasketController : PopoverBasket <SKReceiptObserverDelegate, UIAlertViewDelegate>

- (BOOL)didReceiveNotification:(NSString *)uuid withAction:(NSString *)identifier;

- (void)didBecomeActive;

- (void)didUpdateReceipt:(BOOL)valid;

- (void)didChangeExternally;

@end
