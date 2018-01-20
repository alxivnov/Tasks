//
//  CustomCell+Blink.m
//  Done!
//
//  Created by Alexander Ivanov on 14.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ColorScheme.h"
#import "Constants.h"
#import "CustomCell+Blink.h"
#import "Palette.h"
#import "UIHelper.h"
#import "UIView+Animation.h"

@implementation CustomCell (Blink)

- (void)blink:(NSTimeInterval)duration {
	UIColor *titleColor = self.title.backgroundColor;
	UIColor *subtitleColor = self.subtitle.backgroundColor;
	
	UIColor *clearColor = [UIColor clearColor];
	
	self.textLabel.opaque = NO;
	self.textLabel.backgroundColor = clearColor;
	self.detailTextLabel.opaque = NO;
	self.detailTextLabel.backgroundColor = clearColor;

	[self blink:[ColorScheme instance].lightGrayColor duration:duration * 2.0 completion:^(BOOL finished) {
		self.textLabel.opaque = YES;
		self.textLabel.backgroundColor = titleColor;
		self.detailTextLabel.opaque = YES;
		self.detailTextLabel.backgroundColor = subtitleColor;
	}];
}

@end
