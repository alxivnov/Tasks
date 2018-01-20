//
//  UITableViewCell+Animation.m
//  Done!
//
//  Created by Alexander Ivanov on 18.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Images.h"
#import "ColorScheme.h"
#import "UITableViewCell+Tour.h"
#import "UIView+Tour.h"
#import "UIView+Position.h"

@implementation UITableViewCell (Tour)

- (void)hint:(UIPosition)position {
	UIImage *arrow = position == UIPositionLeft ? [Images arrowForward] : position == UIPositionRight ? [Images arrowBack] : Nil;
	
	UIImageView *image = [[UIImageView alloc] initWithImage:arrow];
	image.alpha = 0.5;
	image.tintColor = [ColorScheme instance].blackColor;
	
	[image centerInSuperview:self];
//	[image moveAway:[UIView invertDirection:direction] inView:self];
	
	image.hidden = YES;
	[self addSubview:image];
	
	UIView *view = self.detailTextLabel.text && self.detailTextLabel.frame.size.width > self.textLabel.frame.size.width ? self.detailTextLabel : self.textLabel;
	[image bump:view from:position completion:^(BOOL finished) {
		[image removeFromSuperview];
	}];
}

- (void)hintLeft {
	[self hint:UIPositionLeft];
}

- (void)hintRight {
	[self hint:UIPositionRight];
}

@end
