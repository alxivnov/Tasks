//
//  SortableCell.m
//  Done!
//
//  Created by Alexander Ivanov on 21.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "OrderableCell.h"
#import "Constants.h"

#import "NSObject+Cast.h"
#import "UITableViewCell+Focus.h"
#import "UITableViewCell+TableView.h"

@interface OrderableCell ()
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, weak) UITableViewWithScroll *table;
@property (nonatomic, assign) CGPoint point;
@end

@implementation OrderableCell

@dynamic delegate;

- (UITableView *)table {
	if (!_table)
		_table = (UITableViewWithScroll *)[self tableView];
	
	return _table;
}

- (void)setPoint:(CGPoint)point {
	if (CGPointEqualToPoint(_point, point))
		return;

#warning Improve sorting!
	NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:point];
	CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
	CGFloat halfHeight = rect.size.height / 2.0;
	CGFloat location = point.y - self.table.contentOffset.y;
	if (location < halfHeight)
		return;
	
	if ([self.delegate respondsToSelector:@selector(didMove:toOffset:)])
		[self.delegate didMove:self toOffset:CGPointMake(point.x - self.origin.x, point.y - self.origin.y)];

	CGFloat center = rect.origin.y + halfHeight;
	if (indexPath != Nil && ((self.origin.y > point.y && center > point.y) || (self.origin.y < point.y && center < point.y))) {
		OrderableCell *cell = [[self.table cellForRowAtIndexPath:indexPath] as:[OrderableCell class]];
		if (cell != self && [cell isUnfocused]) {
			if ([cell.textLabel.text isEqualToString:self.textLabel.text])
				return;
			if ([self.delegate respondsToSelector:@selector(didMove:toIndexPath:)])
				[self.delegate didMove:self toIndexPath:indexPath];
		}
	}

	_point = point;
}

- (void)press:(UILongPressGestureRecognizer *)sender {
	if (self.isEditing)
		return;
	
	if (sender.state == UIGestureRecognizerStateBegan) {
		if ([self.delegate respondsToSelector:@selector(didBeginMoving:)])
			[self.delegate didBeginMoving:self];
		
		self.origin = [sender locationInView:[self tableView]];
		
		self.isOrdering = YES;
	} else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed) {
		[self.table stopScrolling];
		
		
		if ([self.delegate respondsToSelector:@selector(didEndMoving:)])
			[self.delegate didEndMoving:self];
		
		self.origin = CGPointZero;
		
		self.isOrdering = NO;
	} else if (sender.state == UIGestureRecognizerStateChanged) {
		self.point = [sender locationInView:self.table];

		
		CGFloat y = self.point.y - self.table.contentOffset.y;
		BOOL scrollDown = y >= self.table.bounds.size.height - GUI_AUTO_SCROLL_HEIGHT;
		BOOL scrollUp = y <= GUI_AUTO_SCROLL_HEIGHT;
		
//		if (self.table.isScrolling) {
//			if (!scrollDown && !scrollUp)
//				[self.table stopScrolling];
//		} else {
			if (scrollDown)
				[self.table scrollDown:self];
			else if (scrollUp)
				[self.table scrollUp:self];
			else
				[self.table stopScrolling];
//		}
	}
}

- (void)tableView:(UITableViewWithScroll *)tableView didScroll:(CGFloat)offset {
	if ([self.delegate respondsToSelector:@selector(refocus:)])
		[self.delegate refocus:self];
	
	self.point = CGPointMake(self.point.x, self.point.y + offset);
}

@end
