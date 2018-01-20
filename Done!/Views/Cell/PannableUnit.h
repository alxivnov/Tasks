//
//  PannableCellSection.h
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Action.h"

#define IMAGE_HEIGHT 25.0
#define IMAGE_WIDTH 25.0

@interface PannableUnit : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIImage *highlightImage;
@property (strong, nonatomic) UIColor *highlightColor;
@property (strong, nonatomic) UIImage *presentImage;
@property (strong, nonatomic) UIColor *presentColor;
@property (strong, nonatomic) UIImage *dismissImage;
@property (strong, nonatomic) UIColor *dismissColor;
@property (assign, nonatomic) CGFloat width;

+ (PannableUnit *)leftBorder;
+ (PannableUnit *)done;
+ (PannableUnit *)deferral;
+ (PannableUnit *)calendar;
+ (PannableUnit *)delegate;
+ (PannableUnit *)rightBorder;
+ (PannableUnit *)remove;
+ (PannableUnit *)repeat;
+ (PannableUnit *)folder;
+ (PannableUnit *)send;

@end
