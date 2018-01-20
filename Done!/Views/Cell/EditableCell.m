//
//  EditableCell.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "EditableCell.h"
#import "ColorScheme.h"
#import "Constants.h"

#import "NSHelper.h"
#import "UIApplication+ViewController.h"
#import "UIHelper.h"
#import "UIView+Position.h"

@interface EditableCell ()
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) UIView *editView;
@property (assign, nonatomic) BOOL multipleLines;
@end

@implementation EditableCell

- (NSString *)editedText {
	return [self.editView performSelector:@selector(text)];
}


- (CGRect)textFieldFrame {
	CGFloat xMargin = [UIHelper margin:Nil];
	CGFloat yMargin = 11.0;
	
	CGFloat x = 0;
	CGFloat y = 0;
	CGFloat width = 0;
	CGFloat height = 0;
	if (self.title.text) {
		x = self.title.frame.origin.x;
		y = self.title.frame.origin.y;
		width = self.content.bounds.size.width - x - xMargin;
		height = self.title.frame.size.height;
	} else {
		x = xMargin;
		y = yMargin;
		width = self.content.bounds.size.width - x - xMargin;
		height = self.content.bounds.size.height - y - yMargin;
	}
	
	return CGRectMake(x, y, width, height);
}

- (void)setTextFieldFrame {
	if (!_textField)
		return;
	
	CGRect frame = [self textFieldFrame];
	
	if (_textField.frame.size.width != frame.size.width)
		_textField.frame = frame;
}

- (UITextField *)textField {
	if (!_textField && !self.multipleLines) {
		_textField = [[UITextField alloc] initWithFrame:[self textFieldFrame]];
//		_textField.autocorrectionType = UITextAutocorrectionTypeNo;
//		_textField.borderStyle = UITextBorderStyleRoundedRect;
		_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		_textField.delegate = self;
		_textField.hidden = YES;
		
		_textField.backgroundColor = self.title.backgroundColor;
		_textField.font = self.title.font;
		_textField.textColor = self.title.textColor;
		
		_textField.keyboardAppearance = [ColorScheme instance].keyboardAppearance;
		_textField.returnKeyType = UIReturnKeyDone;
		
		[self.content addSubview:_textField];
	}
	
	return _textField;
}

- (UITextView *)textView {
	if (!_textView && self.multipleLines) {
		_textView = [[UITextView alloc] initWithFrame:[self textFieldFrame]];
//		_textField.autocorrectionType = UITextAutocorrectionTypeNo;
//		_textField.borderStyle = UITextBorderStyleRoundedRect;
//		_textView.clearButtonMode = UITextFieldViewModeWhileEditing;
		_textView.delegate = self;
		_textView.hidden = YES;
		_textView.textContainerInset = UIEdgeInsetsMake(0.0, -5.0, 0.0, -5.0);
		
		_textView.backgroundColor = self.title.backgroundColor;
		_textView.font = self.title.font;
		_textView.textColor = self.title.textColor;
		
		_textView.keyboardAppearance = [ColorScheme instance].keyboardAppearance;
		_textView.returnKeyType = UIReturnKeyDone;
		
		[self.content addSubview:_textView];
	}
	
	return _textView;
}

- (UIView *)editView {
	return self.multipleLines ? self.textView : self.textField;
}

- (void)setEditView:(UIView *)editView {
	if (self.multipleLines)
		self.textView = (UITextView *)editView;
	else
		self.textField = (UITextField *)editView;
}

- (BOOL)multipleLines {
	return IOS_8_0 && !self.title.numberOfLines;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self setTextFieldFrame];
}

- (BOOL)isEditing {
	return (_textField && !_textField.hidden) || (_textView && !_textView.hidden);
}

- (void)beginEditing:(NSString *)placeholder {
	if ([self isEditing])
		return;
	
	if ([self.delegate respondsToSelector:@selector(didBeginEditing:)])
		[self.delegate didBeginEditing:self];
	
	PERFORM_SELECTOR_1(self.editView, @selector(setPlaceholder:), placeholder);
	
	[self.editView performSelector:@selector(setAttributedText:) withObject:self.title.tag && self.title.tag < self.title.text.length ? [self.title.attributedText attributedSubstringFromRange:NSMakeRange(0, self.title.tag)] : self.title.attributedText];
	
	if (self.multipleLines) {
		[self.editView performSelector:@selector(setFont:) withObject:self.title.font];
		[self.editView performSelector:@selector(setTextColor:) withObject:self.title.textColor];
	}

	self.title.hidden = YES;
	
	self.editView.hidden = NO;
	
	[self.editView becomeFirstResponder];
	
	if (self.title.text.length > 0)
		[self.editView shake:UIDirectionRight duration:DURATION_XXXS];
}

- (void)endEditing:(NSString *)placeholder {
	if (![self isEditing])
		return;
	
	if ([self.delegate respondsToSelector:@selector(willEndEditing:)])
		[self.delegate willEndEditing:self];
	
	self.title.attributedText = [self.editView performSelector:@selector(attributedText)];
	
	[self.editView removeFromSuperview];
	self.editView.hidden = YES;
	[self.editView performSelector:@selector(setText:) withObject:Nil];
	self.editView = Nil;
	
	self.title.hidden = NO;
	
	if ([self.delegate respondsToSelector:@selector(didEndEditing:)])
		[self.delegate didEndEditing:self];
}

- (void)endEditing {
	if ([self.editView isKindOfClass:[UITextField class]])
		[self.editView endEditing:NO];
	else
		[self.editView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField endEditing:NO];
	
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self endEditing:Nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if (![text isEqualToString:STR_NEW_LINE])
		return YES;
	
	[textView resignFirstResponder];
	return NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[self endEditing:Nil];
}

- (void)tap:(UITapGestureRecognizer *)sender {
	if (self.isEditing)
		return;
	
	if (sender.state == UIGestureRecognizerStateEnded)
		[self beginEditing:Nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	return ![self isEditing] && [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
