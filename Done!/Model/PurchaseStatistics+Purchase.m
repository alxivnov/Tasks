//
//  PurchaseStatistics+Purchase.m
//  Done!
//
//  Created by Alexander Ivanov on 23.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "PurchaseStatistics+Purchase.h"

@implementation PurchaseStatistics (Purchase)

- (BOOL)hasPurchases {
	return self.purchaseRepeat || self.purchaseFolder || self.purchaseLogger;
}

@end
