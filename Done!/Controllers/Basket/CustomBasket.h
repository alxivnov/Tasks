//
//  CustomBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 16.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "UIScrollViewController.h"
#import "UITableViewWithFocus.h"

#define FOCUS_VALUE 0.9

@interface CustomBasket : UIScrollViewController

@property (assign, nonatomic, readonly) NSUInteger count;

@property (strong, nonatomic) UIView *background;

@property (strong, nonatomic) UITableViewWithFocus *table;

@property (assign, nonatomic, readonly) BOOL isReloading;
- (void)willReloadTableView;
- (void)reloadTableView:(BOOL)force;

- (BOOL)updateColorScheme;

@end
