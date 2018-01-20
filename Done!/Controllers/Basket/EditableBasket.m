//
//  EditableBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 14.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "EditableBasket.h"
#import "Constants.h"
#import "EditableBasket+Calendar.h"
#import "Sounds.h"

#import "NSDateDetector.h"
#import "NSHelper.h"
#import "NSIndexPath+Equality.h"
#import "NSObject+Cast.h"
#import "NSString+Calculation.h"
#import "UIHelper.h"

@interface EditableBasket ()
@property (strong, nonatomic) NSIndexPath *editIndexPath;

@property (strong, nonatomic) NSString *editTitle;
@end

@implementation EditableBasket

- (void)tap:(UITapGestureRecognizer *)sender {
	if (self.editIndexPath) {
		if (![self.editIndexPath isEqualToIndexPath:[self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]]]) {
			self.repeatAdd = NO;
			
			EditableCell *cell = [[self.tableView cellForRowAtIndexPath:self.editIndexPath] as:[EditableCell class]];
			[cell endEditing];
		}
	} else {
		[super tap:sender];
	}
}

- (void)didBeginEditing:(EditableCell *)sender {
	if (sender.title.text.length) {
		[Sounds beginEdit];
		
		self.statistics.beginEdit++;
	}
	
	self.editIndexPath = [self.tableView indexPathForCell:sender];
	self.editTitle = sender.title.text;
	
	if (!self.repeatAdd || self.tableView.scrollEnabled) {
		self.tableView.scrollEnabled = NO;
		
		[self.table focusOnCells:ARRAY(sender) withDuration:DURATION_XXS];
	} else {
		[self.table refocusOnCells:ARRAY(sender) withDuration:0];
	}
}

- (void)willEndEditing:(EditableCell *)sender {
	if (sender.editedText.length && !self.editTitle.length && self.repeatAdd)
		return;
	
	[self.table defocusWithDuration:DURATION_XXS];
	
	self.tableView.scrollEnabled = YES;
}

- (void)didEndEditing:(EditableCell *)sender {
	if (!sender.title.text.length || [sender.title.text isWhitespace]) {
		[Sounds remove];
		
		[self remove:self.editIndexPath];
		
		self.statistics.tapRemove++;
	
		self.editIndexPath = Nil;
		self.editTitle = Nil;
		
		self.repeatAdd = NO;
	} else if (!self.editTitle.length) {
		if (!self.repeatAdd)
			[Sounds organize];
		
		if (self.basket.parent) {
			[self editAndSort:self.editIndexPath title:sender.title.text];
		} else {
			NSDateDetector *detector = [[NSDateDetector alloc] initWithString:sender.title.text];
			if (detector.date)
				[self editAndCalendar:self.editIndexPath title:detector.string date:detector.date];
			else
				[self editAndCalendar:self.editIndexPath title:sender.title.text date:Nil];
		}
		
		self.statistics.endAdd++;
		
		[self updateTourPrompt];
		
		self.editIndexPath = Nil;
		self.editTitle = Nil;
		
		if (self.repeatAdd)
			[self add];
	} else {
		[Sounds endEdit];
		
		if (![NSHelper string:self.editTitle isEqualTo:sender.title.text]) {
			[self edit:self.editIndexPath title:sender.title.text];
			
			self.statistics.endEdit++;
		}
		
		self.editIndexPath = Nil;
		self.editTitle = Nil;
	}
}

@end
