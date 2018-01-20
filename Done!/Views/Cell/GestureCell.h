//
//  BaseCell.h
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"

@class GestureCell;

@interface GestureCell : CustomCell <UIGestureRecognizerDelegate>

- (void)tap:(UITapGestureRecognizer *)sender;			// abstract

- (void)doubleTap:(UITapGestureRecognizer *)sender;		// abstract

- (void)press:(UILongPressGestureRecognizer *)sender;	// abstract

- (void)pan:(UIPanGestureRecognizer *)sender;			// abstract

- (void)imageTap:(UITapGestureRecognizer *)sender;		// abstract

@end
