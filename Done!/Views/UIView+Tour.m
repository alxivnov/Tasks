//
//  UILabel+Animation.m
//  Done!
//
//  Created by Alexander Ivanov on 18.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Constants.h"
#import "Palette.h"
#import "UIHelper.h"
#import "UIView+Tour.h"

@implementation UIView (Tour)

- (void)show:(void (^)(BOOL finished))completion {
	self.alpha = 0.0;
	self.hidden = NO;
	[UIView animateWithDuration:DURATION_L delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.alpha = 0.5;
	} completion:^(BOOL finished) {
		self.alpha = 1.0;
		
		[UIView animateWithDuration:DURATION_L delay:DURATION_XL options:UIViewAnimationOptionCurveEaseOut animations:^{
			self.alpha = 0.5;
		} completion:completion];
	}];
}

- (void)bump:(UIView *)view from:(UIPosition)position completion:(void (^)(BOOL finished))completion {
	UIPosition to = [[self class] invertPosition:position];
	
	[self dock:position];
	CGPoint origin = self.center;
	
	self.alpha = 0.5;
	self.hidden = NO;
	
	[UIView animateWithDuration:DURATION_L delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		[self dock:position inside:NO margin:0.0 view:view];
	} completion:^(BOOL finished) {
		self.alpha = 1.0;
		
		[UIView animateWithDuration:DURATION_L delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			CGFloat x = self.center.x - origin.x;
			CGFloat y = self.center.y - origin.y;
			if (fabs(x) > fabs(y))
				[self offsetByX:-x / 10.0];
			else
				[self offsetByY:-y / 10.0];
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:DURATION_L delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				self.alpha = 0.5;
				
				[self dock:to];
			} completion:completion];
		}];
	}];
}

@end
