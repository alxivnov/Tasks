//
//  Action+Folder.h
//  Done!
//
//  Created by Alexander Ivanov on 07.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action.h"

@import UIKit;

@interface Action (Folder)

- (NSString *)folderDescription;

- (NSAttributedString *)folderAttributedDescription:(UIFont *)font;

@end
