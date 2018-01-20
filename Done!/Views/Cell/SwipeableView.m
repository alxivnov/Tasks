//
//  SwipeableView.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 18.01.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "Constants.h"
#import "PannableUnit.h"
#import "SwipeableView.h"
#import "UIHelper.h"
#import "UIView+Gestures.h"

@interface SwipeableView ()
@property (strong, nonatomic) NSArray *units;

@property (copy, nonatomic) void (^action)(PannableUnit *unit);

@property (weak, nonatomic) UIImageView *image;
@end

@implementation SwipeableView

- (instancetype)initWithUnits:(NSArray *)units spacing:(CGFloat)spacing action:(void (^)(PannableUnit *unit))action {
	self = [super initWithFrame:CGRectMake(0.0, 0.0, (IMAGE_WIDTH + spacing) * units.count - spacing, IMAGE_HEIGHT)];
	
	if (self) {
		self.units = units;
		self.action = action;
		
		for (NSUInteger index = 0; index < self.units.count; index++) {
			PannableUnit *unit = self.units[index];
			
			UIImageView *image = [[UIImageView alloc] initWithImage:unit.image];
			image.frame = CGRectMake(self.bounds.origin.x + (IMAGE_WIDTH + spacing) * index, self.bounds.origin.y, unit.image.size.width, unit.image.size.height);
			image.tintColor = unit.color;
			
			image.tag = index;
			image.userInteractionEnabled = YES;
			
			[image addTap:self];
			
			[self addSubview:image];
		}
	}
	
	return self;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
	self.image = (UIImageView *)sender.view;
	
	PannableUnit *unit = self.units[self.image.tag];

	[self.image burst:GUI_BURST_SCALE duration:DURATION_XXS animation:^{
		self.image.image = unit.highlightImage;
		self.image.tintColor = unit.highlightColor;
	} completion:^(BOOL finished) {
		if (self.action)
			self.action(unit);
	}];
}

- (void)cancel {
	PannableUnit *unit = self.units[self.image.tag];
	
	[UIHelper curveEaseInWithDuration:DURATION_XXS animations:^{
		self.image.image = unit.image;
		self.image.tintColor = unit.color;
	} completion:^(BOOL finished) {
		self.image = Nil;
	}];
}

- (UIView *)anchor {
	return self.image;
}

@end
