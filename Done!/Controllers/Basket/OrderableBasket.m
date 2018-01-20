//
//  OrderableBasketController.m
//  Done!
//
//  Created by Alexander Ivanov on 13.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Action+Compare.h"
#import "CGHelper.h"
#import "Constants.h"
#import "NSIndexPath+Equality.h"
#import "OrderableBasket.h"
#import "Palette.h"
#import "Sounds.h"
#import "UIHelper.h"
#import "UIView+Animation.h"
#import "UIView+Position.h"

@interface OrderableBasket ()
@property (strong, nonatomic) UIView *snapshot;
@property (assign, nonatomic) CGPoint snapshotOrigin;

@property (assign, nonatomic) BOOL subtitleHidden;
@property (assign, nonatomic) BOOL imageHidden;

@property (strong, nonatomic) NSIndexPath *orderIndexPath;
@end

@implementation OrderableBasket

- (void)setSnapshot:(UIView *)snapshot {
	if (_snapshot == snapshot)
		return;
	
	if (_snapshot)
		[_snapshot removeFromSuperview];
	
	if (snapshot)
		[self.tableView addSubview:snapshot];
	
	_snapshot = snapshot;
}

- (NSArray *)sameByAction:(Action *)action {
	NSMutableArray *cells = [[NSMutableArray alloc] init];
	
	for (UITableViewCell *cell in [self.tableView visibleCells]) {
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
		NSUInteger row = [self rowForIndexPath:indexPath];
		Action *action0 = [self.basket index:row];
		
		if ([action0 compareByKind:action] == NSOrderedSame)
			[cells addObject:cell];
	}
	
	return cells;
}

- (NSArray *)sameByPath:(NSIndexPath *)indexPath {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	return [self sameByAction:action];
}

- (NSArray *)sameByCell:(UITableViewCell *)cell {
	NSIndexPath *path = [self.tableView indexPathForCell:cell];
	
	return [self sameByPath:path];
}

- (void)didBeginMoving:(OrderableCell *)sender {
	[Sounds beginOrder];
	
	self.statistics.beginOrder++;
	
	self.orderIndexPath = [self.tableView indexPathForCell:sender];
	
	[self.table focusOnCells:[self sameByPath:self.orderIndexPath] withDuration:DURATION_XXS];
	
	
	UIColor *background = sender.backgroundColor;
	sender.backgroundColor = [UIColor clearColor];
	
	UIView *snapshot = [sender.title snapshotViewAfterScreenUpdates:YES];
	
	sender.backgroundColor = background;
	
	snapshot.frame = CGRectMake(sender.frame.origin.x + sender.title.frame.origin.x, sender.frame.origin.y + sender.title.frame.origin.y, sender.title.frame.size.width, sender.title.frame.size.height);
	
	sender.title.hidden = YES;
	
	self.subtitleHidden = sender.subtitle.hidden;
	self.imageHidden = sender.imageView.hidden;
	
	if (!self.subtitleHidden)
		[sender.subtitle animateHideWithDuration:DURATION_XXS];
	if (!self.imageHidden)
		[sender.imageView animateHideWithDuration:DURATION_XXS];
	
	self.snapshot = snapshot;
	
	[UIHelper springInWithDuration:DURATION_S animations:^{
		self.snapshot.transform = CGAffineTransformMakeScale(1.2, 1.2);
		self.snapshot.frame = CGRectMake(sender.title.frame.origin.x, self.snapshot.frame.origin.y, self.snapshot.frame.size.width, self.snapshot.frame.size.height);
		self.snapshot.alpha = 0.8;
	} completion:^(BOOL finished) {
		self.snapshotOrigin = self.snapshot.frame.origin;
	}];
}

- (void)didEndMoving:(OrderableCell *)sender {
	[Sounds endOrder];
	
	self.statistics.endOrder++;
	
	[self.table defocusWithDuration:DURATION_XXS];
	
	
	if (!self.subtitleHidden)
		[sender.subtitle animateShowWithDuration:DURATION_XXS];
	if (!self.imageHidden)
		[sender.imageView animateShowWithDuration:DURATION_XXS];
	
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	
	[UIHelper springInWithDuration:DURATION_S animations:^{
		self.snapshot.transform = CGAffineTransformIdentity;
		
		NSUInteger orderRow = [self rowForIndexPath:self.orderIndexPath];
		NSUInteger row = [self rowForIndexPath:indexPath];
		if (orderRow < row)
			[self.snapshot setOriginWithX:self.snapshot.frame.origin.x andY:self.view.bounds.origin.y - self.snapshot.frame.size.height];
		else if (orderRow > row)
			[self.snapshot setOriginWithX:self.snapshot.frame.origin.x andY:self.view.bounds.size.height];
		else
			[self.snapshot setOriginWithX:sender.frame.origin.x + sender.title.frame.origin.x andY:sender.frame.origin.y + sender.title.frame.origin.y];
		
		self.snapshot.alpha = 1.0;
	} completion:^(BOOL finished) {
		self.snapshot = Nil;
		
		sender.title.hidden = NO;
		
		self.snapshotOrigin = CGPointZero;
	}];
	
	self.orderIndexPath = Nil;
}

- (void)refocus:(OrderableCell *)sender {
	if (self.orderIndexPath)
		[self.table refocusOnCells:[self sameByPath:self.orderIndexPath] withDuration:0];
}

- (void)didMove:(OrderableCell *)sender toOffset:(CGPoint)offset {
	if ([CGHelper pointIsZero:self.snapshotOrigin])
		return;
	
//	[UIHelper curveEaseInWithDuration:DURATION_XXS animations:^{
		self.snapshot.frame = CGRectMake(self.snapshotOrigin.x, self.snapshotOrigin.y + offset.y, self.snapshot.frame.size.width, self.snapshot.frame.size.height);
//	}];
}

- (void)didMove:(OrderableCell *)sender toIndexPath:(NSIndexPath *)indexPath {
	if (self.orderIndexPath && ![self.orderIndexPath isEqualToIndexPath:indexPath]) {
		[self order:self.orderIndexPath newIndexPath:indexPath];

		self.orderIndexPath = indexPath;
	}
}

@end
