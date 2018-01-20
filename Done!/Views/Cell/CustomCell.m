//
//  CustomCell.m
//  Done!
//
//  Created by Alexander Ivanov on 19.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (UIView *)content {
	if (!_content)
		_content = Nil;
	
	return _content;
}

- (UILabel *)title {
	if (!_title)
		_title = self.textLabel;
	
	return _title;
}

- (UILabel *)subtitle {
	if (!_subtitle)
		_subtitle = self.detailTextLabel;
	
	return _subtitle;
}

- (CGSize)sizeThatFits:(CGSize)size {
	if (!self.textLabel.numberOfLines)
		[self layoutIfNeeded];
	
	return [super sizeThatFits:size];
}

@end
