//
//  ScrollableBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 16.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "ScrollableBasket.h"
#import "Constants.h"
#import "Images.h"
#import "Palette.h"
#import "PaletteEx.h"
#import "SocialHelper.h"
#import "Sounds.h"

#import "NSArray+Query.h"
#import "NSObject+Cast.h"
#import "UIApplication+ViewController.h"
#import "UIHelper.h"
#import "UIView+Position.h"
#import "UIViewController+Hierarchy.h"

@interface ScrollableBasket ()
@property (strong, nonatomic) NSArray *doneCells;
@end

@implementation ScrollableBasket

- (NSArray *)doneCells {
	if (!_doneCells)
		_doneCells = [[self.tableView visibleCells] where:^BOOL(UITableViewCell *item) {
			CustomCell *cell = [item as:[CustomCell class]];
			return !cell.title.isEnabled;
		}];
	
	return _doneCells;
}

- (BOOL)hideStatusBarOnScrollDown {
	return YES;
}

- (void)addWithState:(ScrollState)state {
	self.repeatAdd = state == ScrollDownL;

	[self add];
}

- (void)clearWithState:(ScrollState)state {
	if (state == ScrollUpL)
		[self performSegue:GUI_LOGGER fromView:self.view];
	else if ([self.basket last].state == GTD_ACTION_STATE_DONE)
		[self clear];
	else {
		UIImage *image = [self.statisticsView snapshot];
		NSString *text = [self.statisticsView text];
		
		if ([UIHelper iPad:self] && IOS_8_0)
			self.popover = [SocialHelper shareInPopover:self.statisticsView image:image text:text];
		else
			[SocialHelper share:self image:image text:text];
	}
}

- (void)setImageForState:(ScrollState)state {
	if (state == ScrollDownS)
		[self.statisticsView setImage:[Images addLine] andColor:[PaletteEx iosGreen]];
	else if (state == ScrollDownM)
		[self.statisticsView setImage:[Images addFull] andColor:[Palette iosGreen]];
	else if (state == ScrollDownL)
		[self.statisticsView setImage:[Images infinityFull] andColor:[PaletteEx iosGreen]];
	else if (state == ScrollUpL)
		[self.statisticsView setImage:[Images archiveFull] andColor:[PaletteEx iosGray]];
	if ([self.basket last].state == GTD_ACTION_STATE_DONE) {
		if (state == ScrollUpS)
			[self.statisticsView setImage:[Images clearLine] andColor:[PaletteEx iosGray]];
		else if (state == ScrollUpM)
			[self.statisticsView setImage:[Images clearFull] andColor:[Palette iosGray]];
	} else {
		if (state == ScrollUpS)
			[self.statisticsView setImage:[Images shareLine] andColor:[PaletteEx iosBlue]];
		else if (state == ScrollUpM)
			[self.statisticsView setImage:[Images shareFull] andColor:[Palette iosBlue]];
	}
}

- (void)playSoundForState:(ScrollState)state {
	if (self.state > ScrollDownS || self.state < ScrollUpS || state > ScrollDownS || state < ScrollUpS)
		[Sounds beginProcess];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[super scrollViewDidScroll:scrollView];

	CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
	if (offset > 0 && scrollView.contentSize.height > scrollView.bounds.size.height - scrollView.contentInset.top) {
		offset = scrollView.contentOffset.y - scrollView.contentSize.height + scrollView.bounds.size.height;
		
		if (offset < 0)
			offset = 0;
	}
	
	CGFloat rowHeight = self.tableView.rowHeight == UITableViewAutomaticDimension ? self.tableView.estimatedRowHeight : self.tableView.rowHeight;
	CGFloat border = 0;
	ScrollState state = ScrollZero;
	if (offset > 0) {
		border = rowHeight + 30;
		state = offset > self.tableView.bounds.size.height / 4 ? ScrollUpL : offset > border ? ScrollUpM : ScrollUpS;
	} else if (offset < 0) {
		border = -(rowHeight + 10);
		state = offset < -(self.tableView.bounds.size.height / 4) ? ScrollDownL : offset < border ? ScrollDownM : ScrollDownS;
	}
	
	if (state == ScrollZero) {
		if (self.state != state || self.table.isFocusing) {
			[self hideStatistics];
		
			[self.table defocusWithDuration:0];
		}
			
		if (!scrollView.isDragging && scrollView.isDecelerating) {
			if (self.state > ScrollDownS)
				[self addWithState:self.state];
			else if (self.state < ScrollUpS)
				[self clearWithState:self.state];
		}
		
		self.doneCells = Nil;
		
		self.state = state;
	} else {
		if ((scrollView.isDragging || self.helpVisible) && !scrollView.isDecelerating) {
			[self showStatistics:!self.helpVisible withState:state];
			
			if (self.state != state) {
				[UIHelper curveEaseInWithDuration:DURATION_XXS animations:^{
					[self setImageForState:state];
				} completion:Nil];
				
				if (scrollView.isDragging)
					[self playSoundForState:state];
			}
		}
		
		if ((state == ScrollDownS || state == ScrollUpS || self.table.isFocusing) && !self.statisticsView.hidden) {
			[self.statisticsView setOriginWithX:self.statisticsView.frame.origin.x andY:offset > 0
				? self.tableView.bounds.size.height - fminf(offset, border) + 24
				: -fmaxf(offset, border) - self.statisticsView.frame.size.height - 4];
			
			[self.table setFocus:offset / border * self.table.maxFocusValue forCells:state < ScrollZero ? self.doneCells : Nil withDuration:0];
		}
		
		if (scrollView.isDragging && !scrollView.isDecelerating)
			self.state = state;
	}
}

@end
