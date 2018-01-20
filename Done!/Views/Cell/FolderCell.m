//
//  FolderCell.m
//  Done!
//
//  Created by Alexander Ivanov on 06.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "FolderCell.h"

@implementation FolderCell

static NSArray *_leftUnits;
static NSArray *_rightUnits;

- (void)setupActionCell:(NSString *)reuseIdentifier {
	if (!_leftUnits)
		_leftUnits = @[ [PannableUnit leftBorder], [PannableUnit done] ];
	
	if (!_rightUnits)
		_rightUnits = @[ [PannableUnit rightBorder], [PannableUnit remove] ];
	
//	UIUserInterfaceLayoutDirection layout = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
	
	self.leftUnits = _leftUnits;
	self.rightUnits = _rightUnits;
}

@end
