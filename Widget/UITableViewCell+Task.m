//
//  UITableViewCell+Task.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 05.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Folder.h"
#import "Images.h"
#import "NSDate+Calculation.h"
#import "NSDate+Description.h"
#import "Palette.h"
#import "UITableViewCell+Task.h"

@implementation UITableViewCell (Task)

- (void)setup:(Action *)action {
	self.textLabel.attributedText = [action folderAttributedDescription:self.textLabel.font];
	
	if (action.state == GTD_ACTION_STATE_CALENDAR) {
		self.detailTextLabel.text = [action.date descriptionForTime:NSDateFormatterShortStyle];
		self.imageView.image = [Images calendarLine];
		self.imageView.tintColor = [action.date isPast] ? [Palette darkGray] : [Palette red];
	} else {
		self.detailTextLabel.text = Nil;
		self.imageView.image = [Images deferralLine];
		self.imageView.tintColor = [Palette yellow];
	}
}

@end
