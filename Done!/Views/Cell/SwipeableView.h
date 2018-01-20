//
//  SwipeableView.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 18.01.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Position.h"

@interface SwipeableView : UIView

- (instancetype)initWithUnits:(NSArray *)units spacing:(CGFloat)spacing action:(void (^)(PannableUnit *unit))action;

- (void)cancel;

- (UIView *)anchor;

@end
