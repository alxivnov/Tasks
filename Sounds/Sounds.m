//
//  Sound.m
//  Done!
//
//  Created by Alexander Ivanov on 01.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Sounds.h"

@import AudioToolbox;

#define BEEP_GLITCHY @"beep-glitchy"
#define BEEP_HIGHTONE @"beep-hightone"
#define BEEP_HIGHTONE_REVERSE @"beep-hightone-reverse"
#define BEEP_REJECTED @"beep-rejected"
#define BEEP_REJECTED_REVERSE @"beep-rejected-reverse"
#define SLIDE_NETWORK @"slide-network"
#define SLIDE_PAPER @"slide-paper"
#define SLIDE_SCISSORS @"slide-scissors"
#define TAP_PROFESSIONAL @"tap-professional"
#define TAP_KISSY @"tap-kissy"
#define TAP_TOOTHY_6DB @"tap-toothy-6db"
#define TAP_ZIPPER_6DB @"tap-zipper-6db"
#define TAP_ZIPPER_6DB_REVERSE @"tap-zipper-6db-reverse"

#define AIF @"aif"

@implementation Sounds

static BOOL _enabled;

+ (void)on {
	_enabled = YES;
}

+ (void)off {
	_enabled = NO;
	
	NSMutableDictionary *dictionary = [self dictionary];
	
	for (NSString *key in dictionary) {
		SystemSoundID soundId = [dictionary[key] unsignedIntValue];
		AudioServicesDisposeSystemSoundID(soundId);
	}
	
	[dictionary removeAllObjects];
}

static NSMutableDictionary *_dictionary;

+ (NSMutableDictionary *)dictionary {
	if (!_dictionary)
		_dictionary = [[NSMutableDictionary alloc] init];
	
	return _dictionary;
}

+ (void)sound:(NSString *)name {
	if (!_enabled)
		return;
	
	NSMutableDictionary *dictionary = [self dictionary];
	
	SystemSoundID sound = [(NSNumber *)dictionary[name] unsignedIntValue];
	
	if (!sound) {
		NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:AIF subdirectory:Nil];
		AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
		
		dictionary[name] = @(sound);
	}
	
	AudioServicesPlaySystemSound(sound);
}

+ (void)done {
	[self sound:BEEP_HIGHTONE];
}

+ (void)undone {
	[self sound:BEEP_HIGHTONE_REVERSE];
}

+ (void)beginProcess {
	[self sound:TAP_TOOTHY_6DB];
}

+ (void)endProcess {
	[self sound:TAP_KISSY];
}

+ (void)organize {
	[self sound:SLIDE_PAPER];
}

+ (void)add {
	[self sound:TAP_PROFESSIONAL];
}

+ (void)remove {
	[self sound:SLIDE_SCISSORS];
}

+ (void)clear {
	[self sound:SLIDE_SCISSORS];
}

+ (void)beginEdit {
	[self sound:TAP_ZIPPER_6DB];
}

+ (void)endEdit {
	[self sound:TAP_ZIPPER_6DB_REVERSE];
}

+ (void)beginOrder {
	[self sound:BEEP_REJECTED_REVERSE];
}

+ (void)endOrder {
	[self sound:BEEP_REJECTED];
}

+ (void)navigation {
	[self sound:SLIDE_NETWORK];
}

+ (void)compose {
	[self sound:BEEP_GLITCHY];
}

@end
