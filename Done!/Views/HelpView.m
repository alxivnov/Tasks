//
//  HelpView.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 19.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "ColorScheme.h"
#import "HelpView.h"
#import "Images.h"
#import "LocalizationTour.h"
#import "NSArray+Query.h"
#import "ColorScheme.h"
#import "UIColorCache.h"
#import "UIFontCache.h"
#import "UIHelper.h"
#import "UILabel+Size.h"
#import "UIView+Animation.h"
#import "UIView+Position.h"
#import "UIView+Presentation.h"

@interface HelpView ()
@property (copy, nonatomic) void(^completion)();

@property (assign, nonatomic) CGFloat rectCenter;
@property (assign, nonatomic) UIPosition position;

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *textBackground;
@property (strong, nonatomic) UILabel *textLabel;
@end

@implementation HelpView

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc] initWithFrame:self.bounds];

		[self addSubview:_backgroundView];
	}

	return _backgroundView;
}

- (UIImageView *)imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithImage:self.position == UIPositionBottom ? [Images arrowUp] : self.position == UIPositionLeft ? [Images arrowForward] : self.position == UIPositionRight ? [Images arrowBack] : self.position == UIPositionTop ? [Images arrowDown] : Nil];
		_imageView.tintColor = [RGB_CACHE colorWithR:255 G:239 B:103];
		
		[self addSubview:_imageView];
	}
	
	return _imageView;
}

- (UIView *)textBackground {
	if (!_textBackground) {
		_textBackground = [[UIView alloc] init];
		_textBackground.backgroundColor = [RGB_CACHE colorWithR:255 G:239 B:103];

		[self.textBackground corner:8.0];

		[self addSubview:_textBackground];
	}

	return _textBackground;
}

- (UILabel *)textLabel {
	if (!_textLabel) {
		_textLabel = [[UILabel alloc] init];
		_textLabel.font = [FNT_CACHE avenirNext:_textLabel.font.pointSize];
		_textLabel.numberOfLines = 0;
		_textLabel.text = self.position == UIPositionBottom ? [LocalizationTour bottom] : self.position == UIPositionLeft ? [LocalizationTour left] : self.position == UIPositionRight ? [LocalizationTour right] : self.position == UIPositionTop ? [LocalizationTour top] : Nil;
		_textLabel.textAlignment = UIPositionVertical(self.position) ? NSTextAlignmentCenter : NSTextAlignmentLeft;
		_textLabel.textColor = [UIColor blackColor];
		
		[self addSubview:_textLabel];
	}
	
	return _textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame position:(UIPosition)position rect:(CGRect)rect {
	self = [super initWithFrame:frame];
	
	if (self) {
		self.hidden = YES;

		self.backgroundView.alpha = 0.5;
		self.backgroundView.backgroundColor = [ColorScheme instance].blackColor;
		
		self.position = position;
		self.rectCenter = CGRectIsNull(rect) ? 0.0 : rect.origin.y + rect.size.height / 2.0;
	}
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	self.backgroundView.frame = self.bounds;
	
	if (self.rectCenter > 0.0) {
		[self.imageView dock:self.position inside:YES margin:0.0];
		[self.imageView setCenterY:[UIHelper statusBarHeight] + self.rectCenter];
	} else {
		[self.imageView dock:self.position inside:YES margin:8.0];
		[self.imageView setCenterX:[self boundsCenter].x];
	}
	
	BOOL autoSize = [self.textLabel autoSize];
	BOOL center = [self.textLabel centerInSuperview];

	if (autoSize || center)
		self.textBackground.frame = CGRectMake(self.textLabel.frame.origin.x - 16.0, self.textLabel.frame.origin.y - 8.0, self.textLabel.frame.size.width + 32.0, self.textLabel.frame.size.height + 16.0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self hide:self.completion];
}

- (void)show:(void(^)())completion {
	self.completion = completion;
	
	self.imageView.alpha = 0.0;
	self.textBackground.transform = self.textLabel.transform = CGAffineTransformMakeScale(0.9, 0.9);
	
	__weak HelpView *__self = self;
	[self animateSetHidden:NO duration:DURATION_S animation:^{
		__self.imageView.alpha = 1.0;
		__self.textBackground.transform = __self.textLabel.transform = CGAffineTransformIdentity;
	} completion:Nil];
}

- (void)hide:(void(^)())completion {
	__weak HelpView *__self = self;
	[self animateSetHidden:YES duration:DURATION_S animation:^{
		__self.imageView.alpha = 0.0;
		__self.textBackground.transform = __self.textLabel.transform = CGAffineTransformMakeScale(0.9, 0.9);
	} completion:completion];
}

@end
