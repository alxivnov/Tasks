//
//  ActionCell.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Action+Compare.h"
#import "Action+Folder.h"
#import "Action+Repeat.h"
#import "ActionCell.h"
#import "ColorScheme.h"
#import "NSAttributedString+Mutable.h"
#import "Palette.h"
#import "PaletteEx.h"

@interface ActionCell ()
@property (assign, nonatomic) NSComparisonResult period;
@end

@implementation ActionCell

- (void)setupActionCell:(NSString *)reuseIdentifier {
	// abstract
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		[self setupActionCell:reuseIdentifier];
	}
	
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	[self setupActionCell:Nil];
}

- (void)setup:(id)object {
	if ([object isKindOfClass:[Action class]]) {
		Action *action = (Action *)object;
		
		self.title.attributedText = [action folderAttributedDescription:self.title.font];
		self.title.tag = [action.title length];
		
		self.title.hidden = NO;
		
		switch (action.state) {
			case GTD_ACTION_STATE_DEFERRAL:
			case GTD_ACTION_STATE_CALENDAR:
				self.unit = action.state == GTD_ACTION_STATE_DEFERRAL ? [PannableUnit deferral] : [PannableUnit calendar];
				
				self.title.enabled = YES;
				
				self.subtitle.text = [action repeatDateDescription];
				
				self.imageView.hidden = NO;
				self.imageView.image = self.unit.image;
				
				self.period = [action periodize];
				if (action.date == Nil) {
					self.lineColor = [Palette lightGray];
					self.fullColor = [PaletteEx lightGray];
					self.imageView.tintColor = [Palette lightGray];
					self.subtitle.textColor = [Palette lightGray];
				} else if (self.period == NSOrderedAscending) {
					self.lineColor = [Palette darkGray];
					self.fullColor = [PaletteEx darkGray];
					self.imageView.tintColor = [Palette darkGray];
					self.subtitle.textColor = [Palette darkGray];
				} else if (self.period == NSOrderedSame) {
					self.lineColor = self.unit.presentColor;
					self.fullColor = self.unit.highlightColor;
					self.imageView.tintColor = self.unit.presentColor;
					self.subtitle.textColor = [ColorScheme instance].blackColor;
				} else {
					self.lineColor = self.unit.presentColor;
					self.fullColor = self.unit.highlightColor;
					self.imageView.tintColor = self.unit.presentColor;
					self.subtitle.textColor = [ColorScheme instance].grayColor;
				}
				
				break;
			case GTD_ACTION_STATE_DELEGATE:
				self.unit = [PannableUnit delegate];
				
				self.title.enabled = YES;
				
				self.subtitle.text = action.personDescription;
				self.subtitle.textColor = [ColorScheme instance].blackColor;
				
				self.imageView.hidden = NO;
//				self.imageView.image = [Images delegateLine];
//				self.imageView.tintColor = [Palette blue];
				self.imageView.image = self.unit.image;
				self.imageView.tintColor = self.unit.presentColor;
				
//				self.lineColor = [Palette blue];
//				self.fullColor = [PaletteEx blue];
				self.lineColor = self.unit.presentColor;
				self.fullColor = self.unit.highlightColor;
				break;
			case GTD_ACTION_STATE_DONE:
				self.unit = [PannableUnit done];
				
				
				self.title.attributedText = [self.title.attributedText strikethrough];
				
				
				self.title.enabled = NO;
				
				self.subtitle.text = Nil;
				
				self.imageView.hidden = NO;
//				self.imageView.image = [Images doneLine];
//				self.imageView.tintColor = [Palette green];
				self.imageView.image = self.unit.image;
				self.imageView.tintColor = self.unit.presentColor;
				
//				self.lineColor = [Palette green];
//				self.fullColor = [PaletteEx green];
				self.lineColor = self.unit.presentColor;
				self.fullColor = self.unit.highlightColor;
				break;
			default:
				self.title.enabled = YES;
				
				self.subtitle.text = Nil;
				
				self.imageView.hidden = YES;
				self.imageView.image = Nil;
				
				self.unit = Nil;
				break;
		}
		
		if (!self.subtitle.frame.size.height || !self.subtitle.frame.size.width)
			[self layoutSubviews];
	}
}

@end
