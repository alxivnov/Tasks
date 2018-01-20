//
//  CustomBasket+Hint.m
//  Done!
//
//  Created by Alexander Ivanov on 15.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Constants.h"
#import "CustomBasket+Hint.h"
#import "NSString+Calculation.h"
#import "ColorScheme.h"
#import "UIFontCache.h"
#import "UILabel+Size.h"
#import "UIView+Animation.h"

@implementation CustomBasket (Hint)

- (void)hint:(NSString *)text {
	UILabel *label = [[UILabel alloc] init];
	label.alpha = GUI_ALPHA;
	label.font = [FNT_CACHE avenirNext:label.font.pointSize];
	label.hidden = YES;
	label.numberOfLines = 0;
	label.text = text;
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [ColorScheme instance].blackColor;
	[label autoSize];
	label.center = self.background.center;
	[self.background addSubview:label];
	[label animateShowWithDuration:DURATION_L andCompletion:^{
		[label animateHideWithDuration:DURATION_XL * [text numberOfLines] andCompletion:^{
			[label removeFromSuperview];
		}];
	}];
}

@end
