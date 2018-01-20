//
//  PaletteEx.m
//  Done!
//
//  Created by Alexander Ivanov on 21.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "PaletteEx.h"
#import "UIColorCache.h"

@implementation PaletteEx

+ (UIColor *)red {
	return [RGB_CACHE colorWithR:195 G:2 B:51];
}

+ (UIColor *)orange {
	return [RGB_CACHE colorWithR:253 G:121 B:20];
}

+ (UIColor *)yellow {
	return [RGB_CACHE colorWithR:254 G:211 B:0];
}

+ (UIColor *)green {
	return [RGB_CACHE colorWithR:0 G:158 B:107];
}

+ (UIColor *)blue {
	return [RGB_CACHE colorWithR:0 G:135 B:188];
}

+ (UIColor *)violet {
	return [RGB_CACHE colorWithR:168 G:73 B:140];
}

+ (UIColor *)darkGray {
	return [RGB_CACHE colorWithR:84 G:85 B:85];
}

+ (UIColor *)lightGray {
	return [RGB_CACHE colorWithR:127 G:128 B:128];
}

+ (UIColor *)iosGreen {
	return [RGB_CACHE colorWithR:76 G:216 B:100];
}

+ (UIColor *)iosRed {
	return [RGB_CACHE colorWithR:254 G:59 B:48];
}

+ (UIColor *)iosBlue {
	return [RGB_CACHE colorWithR:0 G:122 B:254];
}

+ (UIColor *)iosGray {
	return [RGB_CACHE colorWithR:199 G:199 B:203];
}

@end
