//
//  SortableCell.h
//  Done!
//
//  Created by Alexander Ivanov on 21.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "EditableCell.h"
#import "UITableViewWithScroll.h"

@class OrderableCell;

@protocol OrderableCellDelegate <NSObject>

@optional

- (void)refocus:(OrderableCell *)sender;

- (void)didMove:(OrderableCell *)sender toOffset:(CGPoint)offset;
- (void)didMove:(OrderableCell *)sender toIndexPath:(NSIndexPath *)indexPath;

- (void)didBeginMoving:(OrderableCell *)sender;
- (void)didEndMoving:(OrderableCell *)sender;

@end

@interface OrderableCell : EditableCell <UITableViewWithScrollDelegate>

@property (nonatomic, assign) BOOL isOrdering;

@property (nonatomic, assign) id <OrderableCellDelegate, EditableCellDelegate> delegate;

@end
