//
//  Sound.h
//  Done!
//
//  Created by Alexander Ivanov on 01.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BEEP_PIANO @"beep-piano"
#define BEEP_GUITAR @"beep-guitar"
#define BEEP_XYLO @"beep-xylo"
#define LOOP_JUST_AS_YOU_ARE_2 @"just-as-you-are-[loop-2]"
#define LOOP_JUST_AS_YOU_ARE_3 @"just-as-you-are-[loop-3]"

#define AIFF @"aiff"

@interface Sounds : NSObject

+ (void)on;
+ (void)off;

+ (void)done;
+ (void)undone;
+ (void)beginProcess;
+ (void)endProcess;
+ (void)organize;
+ (void)add;
+ (void)remove;
+ (void)clear;
+ (void)beginEdit;
+ (void)endEdit;
+ (void)beginOrder;
+ (void)endOrder;

+ (void)navigation;
+ (void)compose;

@end
