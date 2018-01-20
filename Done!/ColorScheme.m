//
//  ColorScheme.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 05.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ColorScheme.h"
#import "CustomBasket.h"
#import "Palette.h"
#import "PaletteEx.h"
#import "Workflow.h"

#import "NSDate+Calculation.h"
#import "NSHelper.h"
#import "UIApplication+ViewController.h"

@interface ColorScheme ()
@property (assign, nonatomic) NSNumber *darkTheme;
@end

@implementation ColorScheme

- (NSNumber *)darkTheme {
	if (!_darkTheme) {
		if (GLOBAL.settings.theme == 1)
			_darkTheme = @YES;
		else if (GLOBAL.settings.theme == 2)
			_darkTheme = @NO;
		else {
			NSTimeInterval time = [[NSDate date] timeComponent];
			_darkTheme = @(time < 8*TIME_HOUR || time >= 20*TIME_HOUR);
		}
	}
	
	return _darkTheme;
}

- (BOOL)update {
	NSNumber *darkTheme = self.darkTheme;
	self.darkTheme = Nil;
	return darkTheme.boolValue != self.darkTheme.boolValue;
}

- (UIColor *)blackColor {
	return !self.darkTheme.boolValue ? [Palette black] : [Palette white];
}

- (UIColor *)darkGrayColor {
	return !self.darkTheme.boolValue ? [Palette darkGray] : [Palette lightGray];
}

- (UIColor *)grayColor {
	return [Palette gray];
}

- (UIColor *)lightGrayColor {
	return !self.darkTheme.boolValue ? [Palette lightGray] : [Palette darkGray];
}

- (UIColor *)whiteColor {
	return !self.darkTheme.boolValue ? [Palette white] : [Palette black];
}

- (UIColor *)lightGrayColorEx {
	return !self.darkTheme.boolValue ? [PaletteEx lightGray] : [PaletteEx darkGray];
}

- (UIKeyboardAppearance)keyboardAppearance {
	return !self.darkTheme.boolValue ? UIKeyboardAppearanceDefault : UIKeyboardAppearanceDark;
}

- (UIStatusBarStyle)statusBarStyle {
	return !self.darkTheme.boolValue ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

static id _instance;

+ (instancetype)instance {
	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}
	
	return _instance;
}

@end
