//
//  BaseCell.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "GestureCell.h"
#import "UITableViewCell+Focus.h"
#import "UIView+Gestures.h"

@interface GestureCell ()
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTap;
@property (strong, nonatomic) UILongPressGestureRecognizer *press;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (strong, nonatomic) UITapGestureRecognizer *imageTap;
@end

@implementation GestureCell

- (void)tap:(UITapGestureRecognizer *)sender {
	// abstract
}

- (void)doubleTap:(UITapGestureRecognizer *)sender {
	// abstract
}

- (void)press:(UILongPressGestureRecognizer *)sender {
	// abstract
}

- (void)pan:(UIPanGestureRecognizer *)sender {
	// abstract
}

- (void)imageTap:(UITapGestureRecognizer *)imageTap {
	// abstract
}

- (UITapGestureRecognizer *)tap {
	if (!_tap) {
		_tap = [self.title addTap:self];
		[_tap requireGestureRecognizerToFail:self.doubleTap];
	}
	
	return _tap;
}

- (UITapGestureRecognizer *)doubleTap {
	if (!_doubleTap) {
		_doubleTap = [self.content addTap:self :@selector(doubleTap:)];
		_doubleTap.numberOfTapsRequired = 2;
	}
	
	return _doubleTap;
}

- (UILongPressGestureRecognizer *)press {
	if (!_press)
		_press = [self.content addLongPress:self :@selector(press:)];
	
	return _press;
}

- (UIPanGestureRecognizer *)pan {
	if (!_pan)
		_pan = [self.content addPan:self];
	
	return _pan;
}

- (UITapGestureRecognizer *)imageTap {
	if (!_imageTap)
		_imageTap = [self.imageView addTap:self :@selector(imageTap:)];
	
	return _imageTap;
}

- (void)setupGestureCell {
	self.tap.delegate = self;
	
	self.doubleTap.delegate = self;
	
	self.press.delegate = self;
	
    self.pan.delegate = self;
	
	self.imageTap.delegate = self;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
        [self setupGestureCell];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	
    [self setupGestureCell];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if ([gestureRecognizer numberOfTouches] > 1)
		return NO;
	
	if (!(self.title.isEnabled || gestureRecognizer == self.imageTap || gestureRecognizer == self.doubleTap) || ![self isUnfocused])
		return NO;
	
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
		CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
		return fabs(translation.x) > fabs(translation.y);
	}
	
	return YES;
}

@end
