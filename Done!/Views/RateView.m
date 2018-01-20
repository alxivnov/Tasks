//
//  RateView.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 06.12.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Palette.h"
#import "RateView.h"
#import "UIHelper.h"

#define X 8.0
#define Y 2.0

@implementation RateView

@synthesize imageView = _imageView;

- (CGRect)imageFrame:(UIImage *)image {
	CGFloat x = self.bounds.origin.x;
	CGFloat y = self.bounds.origin.y + Y;
	CGFloat width = self.bounds.size.width;
	CGFloat height = self.bounds.size.height / 2.0;
	if (image) {
		x += (width - image.size.width) / 2.0;
		y += (height - image.size.height) / 2.0;
		width = image.size.width;
		height = image.size.height;
	}
	return CGRectMake(x, y, width, height);
}

- (UIImageView *)imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithImage:Nil];
		
		[self addSubview:_imageView];
	}
	
	return _imageView;
}

- (UIImage *)image {
	return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
	self.imageView.image = image;
}

@synthesize textLabel = _textLabel;

- (CGRect)labelFrame {
	CGFloat y = self.bounds.size.height / 2.0;
	return CGRectMake(self.bounds.origin.x + X, self.bounds.origin.y + y, self.bounds.size.width - X * 2, y);
}

- (UILabel *)textLabel {
	if (!_textLabel) {
		_textLabel = [[UILabel alloc] initWithFrame:[self labelFrame]];
		_textLabel.adjustsFontSizeToFitWidth = YES;
		_textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
		_textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.textColor = [Palette darkGray];
		
		
		[self addSubview:_textLabel];
	}
	
	return _textLabel;
}

- (NSString *)text {
	return self.textLabel.text;
}

- (void)setText:(NSString *)text {
	self.textLabel.text = text;
}

- (void)layoutSubviews {
	if (_imageView)
		_imageView.frame = [self imageFrame:_imageView.image];
	
	if (_textLabel)
		_textLabel.frame = [self labelFrame];
}

- (void)open:(NSString *)string withDuration:(NSTimeInterval)duration {
	if (duration > 0) {
		UIColor *color = self.backgroundColor;
		
		[UIHelper curveEaseOutWithDuration:duration animations:^{
			self.backgroundColor = [Palette iosGray];
		} completion:^(BOOL finished) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
			
			[UIHelper curveEaseInWithDuration:duration animations:^{
				self.backgroundColor = color;
			} completion:Nil];
		}];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
	}
}

@end
