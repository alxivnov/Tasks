//
//  Palette.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Palette.h"
#import "UIColorCache.h"

@implementation Palette

+ (UIColor *)red {
    return RGB_CACHE.ncsRed;
}

+ (UIColor *)orange {
	return RGB_CACHE.ncsOrange;
}

+ (UIColor *)yellow {
	return RGB_CACHE.ncsYellow;
}

+ (UIColor *)green {
	return RGB_CACHE.ncsGreen;
}

+ (UIColor *)blue {
	return RGB_CACHE.ncsBlue;
}

+ (UIColor *)violet {
	return RGB_CACHE.ncsViolet;
}

+ (UIColor *)black {
	return [RGB_CACHE colorWithW:0];
}

+ (UIColor *)darkGray {
	return [RGB_CACHE colorWithW:85];
}

+ (UIColor *)gray {
	return [RGB_CACHE colorWithW:128];
}

+ (UIColor *)lightGray {
	return [RGB_CACHE colorWithW:170];
}

+ (UIColor *)white {
	return [RGB_CACHE colorWithW:255];
}

+ (UIColor *)iosGreen {
	return RGB_CACHE.iosGreen;
}

+ (UIColor *)iosRed {
	return RGB_CACHE.iosRed;
}

+ (UIColor *)iosBlue {
	return RGB_CACHE.iosBlue;
}

+ (UIColor *)iosGray {
	return RGB_CACHE.iosGray;
}

+ (UIColor *)iosWhite {
	return RGB_CACHE.iosWhite;
}

@end
