//
//  StatisticsView.m
//  Done!
//
//  Created by Alexander Ivanov on 14.05.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Images.h"
#import "NSHelper.h"
#import "Palette.h"
#import "StatisticsView.h"
#import "UIApplication+ViewController.h"
#import "UIColorCache.h"
#import "UIFont+Modification.h"
#import "UIFontCache.h"
#import "UIHelper.h"
#import "UIView+Position.h"

#define STATISTICS_NUMBER_FONT_SIZE 25
#define STATISTICS_STRING_FONT_SIZE 10

@interface StatisticsView ()
@property (strong, nonatomic) UIImageView *image;

@property (strong, nonatomic) UILabel *detailLabel;

@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *stringLabel;

@property (strong, nonatomic) UIImageView *arrow;
@end

@implementation StatisticsView

+ (UIImage *)snapshotWithNumber:(NSString *)number andString:(NSString *)string {
	UIImage *icon = [Images icon80];
	
	UIColor *color = RGB(255, 250, 250);
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	style.alignment = NSTextAlignmentCenter;
	NSDictionary *na = @{ NSFontAttributeName : [[FNT_CACHE avenirNext:STATISTICS_NUMBER_FONT_SIZE] bold], NSForegroundColorAttributeName : color };
	NSDictionary *sa = @{ NSFontAttributeName : [FNT_CACHE avenirNext:STATISTICS_STRING_FONT_SIZE], NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName : style };
	
	CGSize ns = [number sizeWithAttributes:na];
	CGSize ss = [string sizeWithAttributes:sa];
	
	CGRect rect = CGRectMake(0, 0, icon.size.width, icon.size.height);
	
	UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
	
//	CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [Palette white].CGColor);
//	CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
	
	[icon drawInRect:CGRectMake(0, 0, icon.size.width, icon.size.height)];
	[number drawInRect:CGRectMake((rect.size.width - ns.width) / 2.0, rect.size.height / 2.0 - ns.height, ns.width, ns.height) withAttributes:na];
	[string drawInRect:CGRectMake((rect.size.width - ss.width) / 2.0, rect.size.height / 2.0, ss.width, ss.height) withAttributes:sa];
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}

- (CGRect)imageFrame {
	return [self centerRectWithWidth:STATISTICS_IMAGE_SIZE andHeight:STATISTICS_IMAGE_SIZE];
}

- (UIImageView *)image {
	if (!_image) {
		_image = [[UIImageView alloc] initWithFrame:[self imageFrame]];
		_image.opaque = YES;
		
		[self addSubview:_image];
	}
	
	return _image;
}

- (void)setImage:(UIImage *)image andColor:(UIColor *)color {
	if (image)
		self.image.image = image;
	
	if (color)
		self.image.tintColor = color;
}

- (CGRect)leftLabelFrame:(NSAttributedString *)text x:(CGFloat)x y:(CGFloat)y {
	CGFloat width = self.image.frame.origin.x - x;
	CGFloat height = self.image.frame.size.height;
	if (text) {
		CGSize size = [text size];
		y = y + ((height - size.height) / 2);
		width = fminf([text size].width, width);
		height = size.height;
	}
	
	return CGRectMake(x, y - 2.0, width, height + 3.0);
}

- (CGRect)rightLabelFrame:(NSAttributedString *)text x:(CGFloat)x y:(CGFloat)y {
	CGFloat width = x - (self.image.frame.origin.x + self.image.frame.size.width);
	CGFloat height = self.image.frame.size.height;
	if (text) {
		CGSize size = [text size];
		y = y + ((height - size.height) / 2);
		width = fminf([text size].width, width);
		height = size.height;
	}
	
	return CGRectMake(x - width, y - 2.0, width, height + 3.0);
}

- (UILabel *)label:(CGRect)frame :(UIFont *)font :(NSInteger)numberOfLines :(NSTextAlignment)textAlignment {
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.font = font;
	label.numberOfLines = numberOfLines;
	label.opaque = YES;
	label.textAlignment = textAlignment;
	label.textColor = self.color;
	
	return label;
}

- (CGRect)detailLabelFrame:(NSAttributedString *)text {
	return [self leftLabelFrame:text x:[UIHelper margin:Nil] y:self.image.frame.origin.y + 1];
}

- (UILabel *)detailLabel {
	if (!_detailLabel) {
		_detailLabel = [self label:[self detailLabelFrame:Nil] :[[FNT_CACHE avenirNext:STATISTICS_NUMBER_FONT_SIZE] bold] :1 :NSTextAlignmentLeft];
		
		[self addSubview:_detailLabel];
	}
	
	return _detailLabel;
}

- (CGRect)numberLabelFrame:(NSAttributedString *)text {
	return [self rightLabelFrame:text x:self.bounds.size.width - [UIHelper margin:Nil] y:self.image.frame.origin.y + 1];
}

- (UILabel *)numberLabel {
	if (!_numberLabel) {
		_numberLabel = [self label:[self numberLabelFrame:Nil] :[[FNT_CACHE avenirNext:STATISTICS_NUMBER_FONT_SIZE] bold] :1 :NSTextAlignmentRight];
		
		[self addSubview:_numberLabel];
	}
	
	return _numberLabel;
}

- (CGRect)stringLabelFrame:(NSAttributedString *)text {
	return [self rightLabelFrame:text x:self.numberLabel.frame.origin.x - 5 y:self.image.frame.origin.y - 1];
}

- (UILabel *)stringLabel {
	if (!_stringLabel) {
		_stringLabel = [self label:[self stringLabelFrame:Nil] :[FNT_CACHE avenirNext:STATISTICS_STRING_FONT_SIZE] :2 :NSTextAlignmentRight];
		
		[self addSubview:_stringLabel];
	}
	
	return _stringLabel;
}

- (void)setDetail:(NSString *)detail {
	if (![self.detailLabel.text isEqualToString:detail]) {
		self.detailLabel.text = detail;
		self.detailLabel.frame = [self detailLabelFrame:self.detailLabel.attributedText];
	}
}

- (void)setNumber:(NSNumber *)number andString:(NSString *)string {
	NSString *numberDescription = [number description];
	if (![self.numberLabel.text isEqualToString:numberDescription]) {
		self.numberLabel.text = numberDescription;
		self.numberLabel.frame = [self numberLabelFrame:self.numberLabel.attributedText];
	}
	
	if (![self.stringLabel.text isEqualToString:string]) {
		self.stringLabel.text = string;
		self.stringLabel.frame = [self stringLabelFrame:self.stringLabel.attributedText];
	}
}

- (void)setFrame:(CGRect)frame {
	BOOL didChangeWidth = super.frame.size.width != frame.size.width;
	
	[super setFrame:frame];
	
	if (didChangeWidth) {
		self.image.frame = [self imageFrame];
		self.detailLabel.frame = [self detailLabelFrame:self.detailLabel.attributedText];
		self.numberLabel.frame = [self numberLabelFrame:self.numberLabel.attributedText];
		self.stringLabel.frame = [self stringLabelFrame:self.stringLabel.attributedText];
	}
}

- (void)setColor:(UIColor *)color {
	if (_color == color)
		return;
	
	_color = color;
	
	self.arrow.tintColor  = self.color;
	_detailLabel.textColor = self.color;
	_numberLabel.textColor = self.color;
	_stringLabel.textColor = self.color;
}

- (void)setArrowForDirection:(UIDirection)direction {
	if (direction == UIDirectionDown || direction == UIDirectionUp) {
		UIImage *image;
		CGFloat y;
		if (direction == UIDirectionDown) {
			image = [Images arrowDown];
			y = self.image.frame.origin.y + self.image.frame.size.height;
		} else {
			image = [Images arrowUp];
			y = self.image.frame.origin.y - image.size.height;
		}
		
		if (!self.arrow || self.arrow.frame.origin.y != y) {
			[self.arrow removeFromSuperview];
		
			self.arrow = [[UIImageView alloc] initWithImage:image];
			[self.arrow setOriginWithX:(self.bounds.size.width - image.size.width) / 2 andY:y];
			self.arrow.image = image;
			self.arrow.opaque = YES;
			self.arrow.tintColor = self.color;
		
			[self addSubview:self.arrow];
		}
	} else {
		[self.arrow removeFromSuperview];
		self.arrow = Nil;
	}
}

- (UIImage *)snapshot {
	return [StatisticsView snapshotWithNumber:self.numberLabel.text andString:self.stringLabel.text];
}

- (NSString *)text {
	NSString *text = [NSString stringWithFormat:@"%@ %@", self.numberLabel.text, [self.stringLabel.text stringByReplacingOccurrencesOfString:STR_NEW_LINE withString:STR_SPACE]];
	
	return self.detailLabel.text.length ? [NSString stringWithFormat:@"%@: %@", self.detailLabel.text, text] : text;
}

@end
