//
//  Action+Folder.m
//  Done!
//
//  Created by Alexander Ivanov on 07.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Folder.h"
#import "Constants.h"
#import "NSAttributedString+Mutable.h"
#import "SKInAppPurchase.h"
#import "UIFont+Modification.h"

@implementation Action (Folder)

- (NSString *)folderDescription {
	if (!self.title)
		return Nil;
	
	if (!(self.folder/* && [SKInAppPurchase purchaseByIdentifier:IN_APP_PURCHASE_FOLDER].purchased*/))
		return self.title;
	
	Action *first = [self.folderValues index:0];
	if (first.state == GTD_ACTION_STATE_DONE)
		return self.title;
    
	return [NSString stringWithFormat:@"%@: %@", self.title, first.title];
}

- (NSAttributedString *)folderAttributedDescription:(UIFont *)font {
	if (!self.title)
		return Nil;
	
	if (!(self.folder/* && [SKInAppPurchase purchaseByIdentifier:[Constants inAppPurchaseFolder]].purchased*/))
		return [[NSMutableAttributedString alloc] initWithString:self.title];
	
	NSRange range = NSMakeRange(0, [self.title length]);
	
	Action *first = [self.folderValues index:0];
	NSAttributedString *description = first.state == GTD_ACTION_STATE_DONE
		? [[NSMutableAttributedString alloc] initWithString:self.title]
		: [[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", self.title, first.title]] underline:range];
	
	return [description font:[font bold] forRange:range];
}

@end
