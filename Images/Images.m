//
//  Image.m
//  Done!
//
//  Created by Alexander Ivanov on 07.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Images.h"
#import "UIImageCache.h"

@implementation Images

+ (UIImage *)icon80 {
	return [IMG_CACHE originalImage:@"done-icon-80"];
}

+ (UIImage *)starsFull {
	return [IMG_CACHE originalImage:@"stars-full"];
}

+ (UIImage *)starsLine {
	return [IMG_CACHE originalImage:@"stars-line"];
}

+ (UIImage *)doneFull {
	return [IMG_CACHE templateImage:@"done-done-full"];
}

+ (UIImage *)doneLine {
	return [IMG_CACHE templateImage:@"done-done-line"];
}

+ (UIImage *)deferralFull {
	return [IMG_CACHE templateImage:@"done-deferral-full"];
}

+ (UIImage *)deferralLine {
	return [IMG_CACHE templateImage:@"done-deferral-line"];
}

+ (UIImage *)calendarFull {
	return [IMG_CACHE templateImage:@"done-calendar-full"];
}

+ (UIImage *)calendarLine {
	return [IMG_CACHE templateImage:@"done-calendar-line"];
}

+ (UIImage *)delegateFull {
	return [IMG_CACHE templateImage:@"done-delegate-full"];
}

+ (UIImage *)delegateLine {
	return [IMG_CACHE templateImage:@"done-delegate-line"];
}

+ (UIImage *)addFull {
	return [IMG_CACHE templateImage:@"done-add-full"];
}

+ (UIImage *)addLine {
	return [IMG_CACHE templateImage:@"done-add-line"];
}

+ (UIImage *)infinityFull {
	return [IMG_CACHE templateImage:@"done-infinity-full"];
}

+ (UIImage *)infinityLine {
	return [IMG_CACHE templateImage:@"done-infinity-line"];
}

+ (UIImage *)removeFull {
	return [IMG_CACHE templateImage:@"done-remove-full"];
}

+ (UIImage *)removeLine {
	return [IMG_CACHE templateImage:@"done-remove-line"];
}

+ (UIImage *)backFull {
	return [IMG_CACHE templateImage:@"done-back-full"];
}

+ (UIImage *)backLine {
	return [IMG_CACHE templateImage:@"done-back-line"];
}

+ (UIImage *)downFull {
	return [IMG_CACHE templateImage:@"done-down-full"];
}

+ (UIImage *)downLine {
	return [IMG_CACHE templateImage:@"done-down-line"];
}

+ (UIImage *)upFull {
	return [IMG_CACHE templateImage:@"done-up-full"];
}

+ (UIImage *)upLine {
	return [IMG_CACHE templateImage:@"done-up-line"];
}

+ (UIImage *)clearFull {
	return [IMG_CACHE templateImage:@"done-clear-full"];
}

+ (UIImage *)clearLine {
	return [IMG_CACHE templateImage:@"done-clear-line"];
}

+ (UIImage *)shareFull {
	return [IMG_CACHE templateImage:@"done-share-full"];
}

+ (UIImage *)shareLine {
	return [IMG_CACHE templateImage:@"done-share-line"];
}

+ (UIImage *)archiveFull {
	return [IMG_CACHE templateImage:@"done-archive-full"];
}

+ (UIImage *)archiveLine {
	return [IMG_CACHE templateImage:@"done-archive-line"];
}

+ (UIImage *)repeatFull {
	return [IMG_CACHE templateImage:@"done-repeat-full"];
}

+ (UIImage *)repeatLine {
	return [IMG_CACHE templateImage:@"done-repeat-line"];
}

+ (UIImage *)folderFull {
	return [IMG_CACHE templateImage:@"done-folder-full"];
}

+ (UIImage *)folderLine {
	return [IMG_CACHE templateImage:@"done-folder-line"];
}

+ (UIImage *)purchaseFull {
	return [IMG_CACHE templateImage:@"done-dollar-full"];
}

+ (UIImage *)purchaseLine {
	return [IMG_CACHE templateImage:@"done-dollar-line"];
}

+ (UIImage *)arrowBack {
	return [IMG_CACHE templateImage:@"done-back-16"];
}

+ (UIImage *)arrowDown {
	return [IMG_CACHE templateImage:@"done-down-16"];
}

+ (UIImage *)arrowForward {
	return [IMG_CACHE templateImage:@"done-forward-16"];
}

+ (UIImage *)arrowUp {
	return [IMG_CACHE templateImage:@"done-up-16"];
}

@end
