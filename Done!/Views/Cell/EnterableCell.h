//
//  EnterableCell.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 26.11.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "SwipeableCell.h"

@class EnterableCell;

@protocol EnterableCellDelegate <NSObject>

@optional

- (void)didEnter:(EnterableCell *)sender;

@end

@interface EnterableCell : SwipeableCell

@property (nonatomic, assign) id <EnterableCellDelegate, SwipeableCellDelegate, PannableCellDelegate, OrderableCellDelegate, EditableCellDelegate> delegate;

@end
