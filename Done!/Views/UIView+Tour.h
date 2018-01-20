//
//  UILabel+Animation.h
//  Done!
//
//  Created by Alexander Ivanov on 18.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Position.h"

@interface UIView (Tour)

- (void)show:(void (^)(BOOL finished))completion;

- (void)bump:(UIView *)view from:(UIPosition)position completion:(void (^)(BOOL finished))completion;

@end
