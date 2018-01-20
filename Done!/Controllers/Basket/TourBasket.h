//
//  TourBasketController.h
//  Done!
//
//  Created by Alexander Ivanov on 13.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBasket.h"

@interface TourBasket : CustomBasket

@property (assign, nonatomic, readonly) BOOL helpVisible;

@property (assign, nonatomic, readonly) BOOL onboarding;

- (void)updateTourPrompt;

@end
