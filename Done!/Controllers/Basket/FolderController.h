//
//  FolderController.h
//  Done!
//
//  Created by Alexander Ivanov on 23.03.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ScrollableBasket.h"
#import "SKInAppPurchase.h"

@interface FolderController : ScrollableBasket

+ (Basket *)getValues:(UIViewController *)controller;
+ (void)setValues:(Basket *)basket andTitle:(NSString *)title forViewController:(UIViewController *)controller;

@end
