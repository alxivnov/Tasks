//
//  SwipeableCell.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 29.12.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Constants.h"
#import "NSArray+Query.h"
#import "SwipeableCell.h"
#import "SwipeableView.h"
#import "UIApplication+ViewController.h"
#import "UIGestureRecognizer+Cancel.h"
#import "UIHelper.h"

#define SWIPE_VELOCITY 256.0

@interface SwipeableCell ()
@property (assign, nonatomic) CGFloat velocity;

@property (strong, nonatomic) SwipeableView *view;
@end

@implementation SwipeableCell

@dynamic delegate;

- (void)disposeView {
	if (!_view)
		return;
	
	[_view removeFromSuperview];
	_view = Nil;
}

- (BOOL)isSwiping {
	return _view ? YES : NO;
}

- (void)beginSwipe:(BOOL)forward fromOffset:(CGFloat)offset {
	if ([self.delegate respondsToSelector:@selector(willBeginSwiping:)])
		[self.delegate willBeginSwiping:self];
	
	[self setImageOffset:offset restricted:NO];
	
	NSArray *units = [forward ? self.leftUnits : [self.rightUnits reverse] where:^BOOL(id item) {
		return ((PannableUnit *)item).title && item != self.unit;
	}];
	self.view = [[SwipeableView alloc] initWithUnits:units spacing:[[self class] margin] action:^(PannableUnit *unit) {
		self.selectedUnit = unit;
		
		if ([self.delegate respondsToSelector:@selector(didTap:)])
			[self.delegate didTap:self];
	}];
	
	[self.view setOriginWithX:(forward ? self.content.bounds.origin.x - self.view.frame.size.width : self.content.bounds.origin.x + self.content.bounds.size.width) + offset andY:(self.content.bounds.size.height - self.view.frame.size.height) / 2];
	[self.content addSubview:self.view];
	
	offset = self.view.frame.size.width + [[self class] margin];
	if (self.imageView.hidden)
		offset -= [[self class] marginCorrection];
	if (!forward)
		offset = -offset;
	[UIHelper springInWithDuration:DURATION_M animations:^{
		[self setTitleOffset:offset];
		[self setImageOffset:offset restricted:NO];
		
		[self.view dock:forward ? UIPositionLeft : UIPositionRight inside:YES margin:[[self class] margin]];
	} completion:^(BOOL finished) {
		self.isPanning = NO;
	}];
}

- (void)beginSwipe:(BOOL)forward {
	[self setOrigins];
	
	[self beginSwipe:forward fromOffset:0.0];
}

- (void)endSwipe:(void(^)(BOOL finished))completion {
	if (!self.view)
		return;
	
	if ([self.delegate respondsToSelector:@selector(willEndSwiping:)])
		[self.delegate willEndSwiping:self];
	
	[UIHelper springInWithDuration:DURATION_M animations:^{
		[self setTitleOffset:0.0];
		[self setImageOffset:0.0 restricted:YES];
		
		[self.view setOriginX:self.view.frame.origin.x < self.content.bounds.size.width / 2 ? self.content.bounds.origin.x - self.view.frame.size.width : self.content.bounds.size.width];
	} completion:^(BOOL finished) {
		[self disposeView];
		
		if (completion)
			completion(finished);
	}];
}

- (void)endSwipe {
	[self endSwipe:Nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	return (!self.view || [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] || [gestureRecognizer.view isKindOfClass:[UIImageView class]]) && [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (void)pan:(UIPanGestureRecognizer *)sender {
	if (self.view) {
		if (sender.state != UIGestureRecognizerStateCancelled) {
			[self endSwipe];
			
			[sender cancel];
		}
		return;
	}
	
	CGPoint velocity = [sender velocityInView:self];
	
	if (sender.state == UIGestureRecognizerStateChanged) {
		self.velocity = (self.velocity + velocity.x) / 2.0;
	} else if (sender.state == UIGestureRecognizerStateBegan) {
		self.velocity = fabs(velocity.x);
	} else if (sender.state == UIGestureRecognizerStateEnded) {
//		[[@(self.velocity) description] alertMessage:Nil];
		
		CGPoint translation = [sender translationInView:self];
		BOOL forward = translation.x >= 0.0;
		
		if ((forward ? self.velocity : -self.velocity) >= SWIPE_VELOCITY) {
			if (!self.imageView.hidden) {
				self.imageView.image = self.unit.presentImage;
				self.imageView.tintColor = self.lineColor;
			}
			
			[self disposeImage];
			
			[self setArrowByTranslation:0.0];
			
			self.selectedUnit = Nil;
			
			CGFloat offset = translation.x * (1 - fabs(translation.x) / self.bounds.size.width / 2);
			[self beginSwipe:forward fromOffset:offset];
			
			return;
		}
		
		self.velocity = 0.0;
	} else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed) {
		self.velocity = 0.0;
	}
	
	[super pan:sender];
}

- (void)cancel {
	[super cancel];
	
	[self.view cancel];
		
}

- (void)done {
	[super done];
	
	[self disposeView];
}

- (UIView *)anchor {
	UIView *anchor = [self.view anchor];
	
	return anchor ? anchor : [super anchor];
}

@end
