//
//  StatisticsView.h
//  Done!
//
//  Created by Alexander Ivanov on 14.05.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Animation.h"

#define STATISTICS_IMAGE_SIZE 25

@interface StatisticsView : UIView

+ (UIImage *)snapshotWithNumber:(NSString *)number andString:(NSString *)string;

@property (strong, nonatomic) UIColor *color;

- (void)setImage:(UIImage *)image andColor:(UIColor *)color;

- (void)setNumber:(NSNumber *)number andString:(NSString *)string;

- (void)setDetail:(NSString *)detail;

- (void)setArrowForDirection:(UIDirection)direction;

- (UIImage *)snapshot;

- (NSString *)text;

@end
