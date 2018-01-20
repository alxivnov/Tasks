//
//  OrderableBasketController.h
//  Done!
//
//  Created by Alexander Ivanov on 13.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditableBasket.h"
#import "OrderableCell.h"

@interface OrderableBasket : EditableBasket <OrderableCellDelegate>

@end
