//
//  SwipeableCell.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 29.12.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "PannableCell.h"

@class SwipeableCell;

@protocol SwipeableCellDelegate <NSObject>

@optional

- (void)willBeginSwiping:(SwipeableCell *)sender;

- (void)willEndSwiping:(SwipeableCell *)sender;

@end

@interface SwipeableCell : PannableCell

@property (nonatomic, assign) id <SwipeableCellDelegate, PannableCellDelegate, OrderableCellDelegate, EditableCellDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isSwiping;

- (void)beginSwipe:(BOOL)forward fromOffset:(CGFloat)offset;
- (void)beginSwipe:(BOOL)forward;
- (void)endSwipe:(void(^)(BOOL finished))completion;
- (void)endSwipe;

@end
