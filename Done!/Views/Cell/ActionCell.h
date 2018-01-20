//
//  ActionCell.h
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "EnterableCell.h"

@interface ActionCell : EnterableCell

- (void)setup:(id)object;

- (void)setupActionCell:(NSString *)reuseIdentifier;	// abstract

@end
