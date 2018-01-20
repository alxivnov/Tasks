//
//  PannableCellSection.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "PannableUnit.h"
#import "Action+Repeat.h"
#import "Images.h"
#import "DateHelper.h"
#import "Palette.h"
#import "PaletteEx.h"
#import "Constants.h"
#import "NSDate+Calculation.h"
#import "NSDate+Description.h"
#import "UIHelper.h"

#define BORDER_WIDTH 44
#define UNIT_WIDTH 65

@implementation PannableUnit

- (UIImage *)presentImage {
	return _presentImage ? _presentImage : _image;
}

- (UIColor *)presentColor {
	return _presentColor ? _presentColor : _color;
}

- (UIImage *)dismissImage {
	return _dismissImage ? _dismissImage : _image;
}

- (UIColor *)dismissColor {
	return _dismissColor ? _dismissColor : _color;
}

static PannableUnit *_leftBorder;
static PannableUnit *_done;
static PannableUnit *_deferral;
static PannableUnit *_calendar;
static PannableUnit *_delegate;

static PannableUnit *_rightBorder;
static PannableUnit *_remove;
static PannableUnit *_repeat;
static PannableUnit *_folder;
static PannableUnit *_send;

+ (PannableUnit *)leftBorder {
	if (!_leftBorder) {
		_leftBorder = [[PannableUnit alloc] init];
		
		_leftBorder.title = Nil;
		_leftBorder.image = [Images doneLine];
		_leftBorder.color = [PaletteEx green];
		_leftBorder.highlightImage = [Images doneFull];
		_leftBorder.highlightColor = [PaletteEx green];
		_leftBorder.width = BORDER_WIDTH;
	}
	
	return _leftBorder;
}

+ (PannableUnit *)done {
	if (!_done) {
		_done = [[PannableUnit alloc] init];
		
		_done.title = GTD_ACTION_STATE_DESCRIPTION_DONE;
		_done.image = [Images doneLine];
		_done.color = [Palette green];
		_done.highlightImage = [Images doneFull];
		_done.highlightColor = [PaletteEx green];
		_done.width = UNIT_WIDTH;
		
		_done.presentImage = [Images doneFull];
		_done.dismissImage = [Images doneLine];
	}
	
	return _done;
}

+ (PannableUnit *)deferral {
	if (!_deferral) {
		_deferral = [[PannableUnit alloc] init];
		
		_deferral.title = GTD_ACTION_STATE_DESCRIPTION_DEFERRAL;
		_deferral.image = [Images deferralLine];
		_deferral.color = [Palette yellow];
		_deferral.highlightImage = [Images deferralFull];
		_deferral.highlightColor = [PaletteEx yellow];
		_deferral.width = UNIT_WIDTH;
	}
	
	return _deferral;
}

+ (PannableUnit *)calendar {
	if (!_calendar) {
		_calendar = [[PannableUnit alloc] init];
		
		_calendar.title = GTD_ACTION_STATE_DESCRIPTION_CALENDAR;
		_calendar.image = [Images calendarLine];
		_calendar.color = [Palette red];
		_calendar.highlightImage = [Images calendarFull];
		_calendar.highlightColor = [PaletteEx red];
		_calendar.width = UNIT_WIDTH;
	}
	
	return _calendar;
}

+ (PannableUnit *)delegate {
	if (!_delegate) {
		_delegate = [[PannableUnit alloc] init];
		
		_delegate.title = GTD_ACTION_STATE_DESCRIPTION_DELEGATE;
		_delegate.image = [Images delegateLine];
		_delegate.color = [Palette blue];
		_delegate.highlightImage = [Images delegateFull];
		_delegate.highlightColor = [PaletteEx blue];
		_delegate.width = UNIT_WIDTH;
	}
	
	return _delegate;
}

+ (PannableUnit *)rightBorder {
	if (!_rightBorder) {
		_rightBorder = [[PannableUnit alloc] init];
		
		_rightBorder.title = Nil;
		_rightBorder.image = [Images removeLine];
		_rightBorder.color = [PaletteEx iosRed];
		_rightBorder.highlightImage = [Images removeFull];
		_rightBorder.highlightColor = [PaletteEx iosRed];
		_rightBorder.width = BORDER_WIDTH;
	}
	
	return _rightBorder;
}

+ (PannableUnit *)remove {
	if (!_remove) {
		_remove = [[PannableUnit alloc] init];
		
		_remove.title = GUI_REMOVE;
		_remove.image = [Images removeLine];
		_remove.color = [Palette iosRed];
		_remove.highlightImage = [Images removeFull];
		_remove.highlightColor = [PaletteEx iosRed];
		_remove.width = UNIT_WIDTH;
		
		_remove.presentImage = [Images removeFull];
		_remove.dismissImage = [Images removeLine];
	}
	
	return _remove;
}

+ (PannableUnit *)repeat {
	if (!_repeat) {
		_repeat = [[PannableUnit alloc] init];
		
		_repeat.title = GUI_REPEAT;
		_repeat.image = [Images repeatLine];
		_repeat.color = [Palette orange];
		_repeat.highlightImage = [Images repeatFull];
		_repeat.highlightColor = [PaletteEx orange];
		_repeat.width = UNIT_WIDTH;
	}
	
	return _repeat;
}

+ (PannableUnit *)folder {
	if (!_folder) {
		_folder = [[PannableUnit alloc] init];
		
		_folder.title = GUI_FOLDER;
		_folder.image = [Images folderLine];
		_folder.color = [Palette violet];
		_folder.highlightImage = [Images folderFull];
		_folder.highlightColor = [PaletteEx violet];
		_folder.width = UNIT_WIDTH;
	}
	
	return _folder;
}

+ (PannableUnit *)send {
	if (!_send) {
		_send = [[PannableUnit alloc] init];
		
		_send.title = GUI_SEND;
		_send.image = [Images shareLine];
		_send.color = [Palette iosBlue];
		_send.highlightImage = [Images shareFull];
		_send.highlightColor = [PaletteEx iosBlue];
		_send.width = UNIT_WIDTH;
	}
	
	return _send;
}

@end
