//
//  GestureBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 04.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "GestureBasket.h"
#import "UIView+Gestures.h"

@interface GestureBasket ()
@property (strong, nonatomic) UIPinchGestureRecognizer *pinch;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@end

@implementation GestureBasket

- (void)pinch:(UIPinchGestureRecognizer *)sender {
	// abstract
}

- (UIPinchGestureRecognizer *)pinch {
	if (!_pinch)
		_pinch = [self.view addPinch:self];
	
	return _pinch;
}

- (void)tap:(UITapGestureRecognizer *)sender {
	// abstract
}

- (UITapGestureRecognizer *)tap {
	if (!_tap)
		_tap = [self.view addTap:self];
	
	return _tap;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	return [gestureRecognizer numberOfTouches] <= 2 && ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || self.table.isUnfocused);
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.pinch.delegate = self;
	self.tap.delegate = self;
}

- (UIPinchGestureRecognizer *)transitionGestureRecognizer:(UIPinchTransition *)sender {
	return self.pinch;
}

@end
