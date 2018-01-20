//
//  BasicCell.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Constants.h"
#import "Images.h"
#import "ColorScheme.h"
#import "PannableCell.h"
#import "UIApplication+ViewController.h"
#import "UIHelper.h"
#import "UIView+Position.h"

#define ARROW_HEIGHT 16.0
#define ARROW_WIDTH 16.0

@interface PannableCell()
@property (assign, nonatomic) CGPoint titleOrigin;
@property (assign, nonatomic) CGPoint subtitleOrigin;
@property (assign, nonatomic) CGPoint imageOrigin;

@property (assign, nonatomic, readonly) BOOL isImageVisible;
@property (assign, nonatomic, readonly) BOOL isArrowVisible;

@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UIImageView *arrow;

@property (strong, nonatomic) NSNumber *offsetCorrection;
@end

@implementation PannableCell

@dynamic delegate;

- (NSNumber *)offsetCorrection {
	if (!_offsetCorrection) {
#warning Improve margins!
		CGFloat offsetCorrection = !IOS_9_0 && [UIHelper iPad:Nil] && fmin([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) > fmax(self.frame.size.height, self.frame.size.width) ? 5.0 : 0.0;
		
		_offsetCorrection = [NSNumber numberWithDouble:offsetCorrection];
	}
	
	return _offsetCorrection;
}

- (BOOL)isImageVisible {
	return _image && !_image.hidden;
}

- (BOOL)isArrowVisible {
	return _arrow && !_arrow.hidden;
}

- (void)disposeImage {
	if (!_image)
		return;
	
	[_image removeFromSuperview];
	_image = Nil;
}

- (void)disposeArrow {
	if (!_arrow)
		return;
	
	[_arrow removeFromSuperview];
	_arrow = Nil;
}

- (UIImageView *)image {
	if (!_image) {
		_image = [[UIImageView alloc] initWithFrame:CGRectMake(self.content.bounds.origin.x - IMAGE_WIDTH, (self.content.bounds.size.height - IMAGE_HEIGHT) / 2, IMAGE_WIDTH, IMAGE_HEIGHT)];
		_image.hidden = YES;
		
		[self.content addSubview:_image];
	}
	
	return _image;
}

- (UIImageView *)arrow {
	if (!_arrow) {
		_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.hidden ? self.content.bounds.origin.x : self.imageView.frame.origin.x + self.imageView.frame.size.width, (self.content.bounds.size.height - ARROW_HEIGHT) / 2, ARROW_WIDTH, ARROW_HEIGHT)];
		_arrow.tintColor = [ColorScheme instance].lightGrayColor;
		_arrow.hidden = YES;
		
		[self.content addSubview:_arrow];
	}
	
	return _arrow;
}

- (NSInteger)indexByTranslation:(CGFloat)translation fromUnits:(NSArray *)units {
	NSInteger unit = -1;
	
	BOOL forward = translation >= 0;
	translation = fabs(translation);
	CGFloat width = 0;
	
	for (NSUInteger index = 0; index < [units count] && width <= translation; index++) {
		PannableUnit *pannableUnit = (PannableUnit *)units[index];
		
		if (self.imageView.hidden || !forward)
			unit = index;
		else if (self.unit == pannableUnit)
			continue;
		else
			unit = pannableUnit.title ? index : -1;
		
		width += pannableUnit.width;
	}
	
	return unit;
}

- (void)setArrowByTranslation:(CGFloat)translation {
	if (translation > 0.0) {
		self.arrow.alpha = fabs(translation) / ((PannableUnit *)self.leftUnits[0]).width;
		[self.arrow setOriginWithX:self.isImageVisible ? self.image.frame.origin.x + self.image.frame.size.width : self.imageView.frame.origin.x + self.imageView.frame.size.width andY:self.arrow.frame.origin.y];
		
		self.arrow.image = [Images arrowForward];
		self.arrow.hidden = NO;
	} else if (translation < 0.0) {
		self.arrow.alpha = fabs(translation) / ((PannableUnit *)self.rightUnits[0]).width;
		[self.arrow setOriginWithX:self.image.frame.origin.x - self.arrow.frame.size.width andY:self.arrow.frame.origin.y];
		
		self.arrow.image = [Images arrowBack];
		self.arrow.hidden = NO;
	} else if (self.isArrowVisible) {
		[self disposeArrow];
	}
}

- (void)setOrigins {
	self.titleOrigin = self.title.frame.origin;
	self.subtitleOrigin = self.subtitle.frame.origin;
	
	if (!self.imageView.hidden)
		self.imageOrigin = self.imageView.frame.origin;
}

- (void)setTitleOffset:(CGFloat)offset {
	[self.title setOriginX:self.titleOrigin.x + offset];
	[self.subtitle setOriginX:self.subtitleOrigin.x + offset];
}

- (void)setImageOffset:(CGFloat)offset restricted:(BOOL)flag {
	if (!self.imageView.hidden)
		[self.imageView setOriginX:flag ? fmin(self.imageOrigin.x, self.imageOrigin.x + offset) : self.imageOrigin.x + offset];
}

- (void)imageTap:(UITapGestureRecognizer *)sender {
	if (self.isEditing)
		return;

	UIImageView *image = (UIImageView *)sender.view;
	[image burst:GUI_BURST_SCALE duration:DURATION_XXS animation:^{
		image.image = self.unit.highlightImage;
		image.tintColor = self.fullColor;
	} completion:^(BOOL finished) {
		self.selectedUnit = self.unit;
		
		if ([self.delegate respondsToSelector:@selector(didTap:)])
			[self.delegate didTap:self];
	}];
}

- (void)pan:(UIPanGestureRecognizer *)sender {
	if (self.isEditing)
		return;
	
	CGPoint translation = [sender translationInView:self];
	BOOL forward = translation.x >= 0;

	if (sender.state == UIGestureRecognizerStateChanged) {
		CGFloat offset = translation.x * (1 - fabs(translation.x) / self.bounds.size.width / 2);
		
		[self setTitleOffset:offset];
		[self setImageOffset:offset restricted:YES];
		
		NSArray *units = forward ? self.leftUnits : self.rightUnits;
		NSInteger index = [self indexByTranslation:translation.x fromUnits:units];
		PannableUnit *unit = self.selectedUnit;
		self.selectedUnit = index < 0 ? self.unit : units[index];
		
		if (!self.imageView.hidden) {
			if (forward)
				[UIHelper curveEaseInWithDuration:DURATION_XXS animations:^{
					self.imageView.image = self.selectedUnit.presentImage;
					self.imageView.tintColor = self.selectedUnit == self.unit ? self.lineColor : self.selectedUnit.presentColor;
				}];
		}
		
		if (forward && !self.imageView.hidden) {
			[self disposeImage];
		} else {
			[UIHelper curveEaseInWithDuration:DURATION_XXS animations:^{
				self.image.hidden = NO;
				self.image.image = self.selectedUnit.presentImage;
				self.image.tintColor = self.selectedUnit.presentColor;
			}];
			
			[self.image setOriginWithX:forward ? fminf(offset + [[self class] marginCorrection], IMAGE_WIDTH + [[self class] margin]) - IMAGE_WIDTH - self.offsetCorrection.doubleValue: self.content.bounds.size.width + fmaxf(offset - [[self class] marginCorrection], -(IMAGE_WIDTH + [[self class] margin] - self.offsetCorrection.doubleValue)) andY:self.image.frame.origin.y];
		}
		
		if (self.selectedUnit != unit)
			if ([self.delegate respondsToSelector:@selector(didPan:fromUnit:)])
				[self.delegate didPan:self fromUnit:unit];
		
		if ([self.delegate respondsToSelector:@selector(didPan:toOffset:)])
			[self.delegate didPan:self toOffset:translation.x];
	} else if (sender.state == UIGestureRecognizerStateBegan) {
		self.isPanning = YES;
		
		[self setOrigins];
	} else if (sender.state == UIGestureRecognizerStateEnded) {
		if ([self.delegate respondsToSelector:@selector(willEndPanning:)])
			[self.delegate willEndPanning:self];
		
		CGFloat offset = 0.0;
		if (self.isImageVisible && self.selectedUnit.title)
			offset = forward ? self.image.frame.origin.x + IMAGE_WIDTH - [[self class] marginCorrection] : self.image.frame.origin.x - self.bounds.size.width + [[self class] marginCorrection];
		
		NSArray *units = forward ? self.leftUnits : self.rightUnits;
		NSInteger index = [self indexByTranslation:translation.x fromUnits:units];
		NSTimeInterval duration = DURATION_XXS + (DURATION_S - DURATION_XXS) * (index + 1) / units.count;
		[UIHelper springInWithDuration:duration animations:^{
			[self setTitleOffset:offset];
			[self setImageOffset:offset restricted:YES];
			
			if (self.isImageVisible && !self.selectedUnit.title)
				[self.image setOriginX:forward ? self.content.bounds.origin.x - self.image.frame.size.width : self.content.bounds.size.width];
		} completion:^(BOOL finished) {
			if ([self.delegate respondsToSelector:@selector(didEndPanning:)])
				[self.delegate didEndPanning:self];
			
			if (self.isImageVisible && !self.selectedUnit.title)
				[self disposeImage];
			
			self.isPanning = NO;
		}];
		
		if (self.selectedUnit.title) {
			UIImageView *image = [self isImageVisible] ? self.image : !self.imageView.hidden && self.selectedUnit != self.unit ? self.imageView : Nil;
			
			[image burst:GUI_BURST_SCALE duration:DURATION_XXS delay:DURATION_XXXS animation:^{
				image.image = self.selectedUnit.highlightImage;
				image.tintColor = self.selectedUnit.highlightColor;
			} completion:Nil];
		}
		
		[self setArrowByTranslation:0.0];
	} else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed) {
		[self setTitleOffset:0.0];
		[self setImageOffset:0.0 restricted:YES];
		
		if (!self.imageView.hidden) {
			self.imageView.image = self.unit.image;
			self.imageView.tintColor = self.lineColor;
		}
		
		if ([self.delegate respondsToSelector:@selector(didCancelPanning:)])
			[self.delegate didCancelPanning:self];
		
		[self disposeImage];
		
		self.isPanning = NO;
		
		[self setArrowByTranslation:0.0];
	}
}

- (void)cancel {
	if (self.selectedUnit.title) {
		if (self.isImageVisible) {
			PannableUnit *unit = self.selectedUnit;
			
			[UIHelper springInWithDuration:DURATION_XXS animations:^{
				BOOL forward = self.title.frame.origin.x > self.image.frame.origin.x;
				
				[self setTitleOffset:0.0];
				[self setImageOffset:0.0 restricted:YES];
				
				[self.image setOriginWithX:forward ? self.content.bounds.origin.x - self.image.frame.size.width : self.content.bounds.size.width andY:self.image.frame.origin.y];
				
				self.image.image = unit.dismissImage;
				self.image.tintColor = unit.dismissColor;
			} completion:^(BOOL finished) {
				[self disposeImage];
			}];
		} else if (!self.imageView.hidden) {
			[UIHelper curveEaseInWithDuration:DURATION_XXS animations:^{
				self.imageView.image = self.unit.image;
				self.imageView.tintColor = self.lineColor;
			}];
		}
	}
	
	self.selectedUnit = Nil;
}

- (void)done {
	if (self.selectedUnit.title)
		if (self.isImageVisible)
			[self disposeImage];
	
	self.selectedUnit = Nil;
}

- (UIView *)anchor {
	if ([self isImageVisible])
		return self.image;
	else if (!self.imageView.hidden)
		return self.imageView;
	else
		return self;
}

static CGFloat _margin;

+ (CGFloat)margin {
	if (_margin == 0.0)
		_margin = [UIHelper margin:Nil];

	return _margin;
}

static CGFloat _marginCorrection;

+ (CGFloat)marginCorrection {
	if (_marginCorrection == 0.0)
		_marginCorrection = [self margin] - 15.0;
	
	return _marginCorrection;
}

@end
