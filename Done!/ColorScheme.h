//
//  ColorScheme.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 05.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorScheme : NSObject

- (BOOL)update;

@property (strong, nonatomic) UIColor *blackColor;
@property (strong, nonatomic) UIColor *darkGrayColor;
@property (strong, nonatomic) UIColor *grayColor;
@property (strong, nonatomic) UIColor *lightGrayColor;
@property (strong, nonatomic) UIColor *whiteColor;

@property (strong, nonatomic) UIColor *lightGrayColorEx;

@property (assign, nonatomic) UIKeyboardAppearance keyboardAppearance;
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;

+ (instancetype)instance;

@end
