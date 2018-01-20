//
//  GTDConstants.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 05.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, GTD_ACTION_STATE) {
	GTD_ACTION_STATE_NULL = 0,
	GTD_ACTION_STATE_DONE = (1 << 7),
	GTD_ACTION_STATE_DEFERRAL = (1 << 3),
	GTD_ACTION_STATE_CALENDAR = (1 << 1),
	GTD_ACTION_STATE_DELEGATE = (1 << 5),
};

#define GTD_ACTION_STATE_DESCRIPTION_DONE @"done"
#define GTD_ACTION_STATE_DESCRIPTION_DEFERRAL @"deferral"
#define GTD_ACTION_STATE_DESCRIPTION_CALENDAR @"calendar"
#define GTD_ACTION_STATE_DESCRIPTION_DELEGATE @"delegate"

@interface GTDHelper : NSObject

@end
