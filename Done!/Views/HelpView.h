//
//  HelpView.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 19.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Position.h"

@interface HelpView : UIView

- (instancetype)initWithFrame:(CGRect)frame position:(UIPosition)position rect:(CGRect)rect;

- (void)show:(void(^)())completion;

@end
