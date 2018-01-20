//
//  TourBasketController.m
//  Done!
//
//  Created by Alexander Ivanov on 13.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "CloudStatistics+Help.h"
#import "FocusController.h"
#import "HelpView.h"
#import "InBasketController.h"
#import "NSArray+Query.h"
#import "TourBasket.h"
#import "UIHelper.h"
#import "UITableView+Rows.h"
#import "UITableViewCell+Tour.h"
#import "UIView+Hierarchy.h"
#import "UIView+Position.h"
#import "Workflow.h"

@interface TourBasket ()
@property (assign, nonatomic) NSUInteger appear;
@end

@implementation TourBasket

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if (self.appear)
		return;
	self.appear++;
	
//	if (!IOS_8_0)
		[self updateTourPrompt];
}

- (BOOL)onboarding {
	CloudStatistics *statistics = [Workflow instance].statistics;
	return [statistics tourTop] || ([statistics tourLeft] && [self.tableView visibleCells].count > 0) || ([statistics tourBottom] && [[self.tableView visibleCells] where:^BOOL(id item) {
		return !((UITableViewCell *)item).textLabel.enabled;
	}].count > 0) || ([statistics tourRight] && [self.tableView visibleCells].count > 0);
}

- (void)updateTourPrompt {
	[self performSelector:@selector(setupTour) withObject:Nil afterDelay:DURATION_M];
}

- (void)setupTour {
	if (![self isKindOfClass:[InBasketController class]])
		return;
	
	CloudStatistics *statistics = [Workflow instance].statistics;
	if ([statistics tourTop])
		[self setupTour:UIPositionTop];
	else if ([statistics tourLeft] && [self.tableView visibleCells].count > 0)
		[self setupTour:UIPositionLeft];
	else if ([statistics tourBottom] && [self.tableView.visibleCells where:^BOOL(id item) {
		return !((UITableViewCell *)item).textLabel.enabled;
	}].count > 0)
		[self setupTour:UIPositionBottom];
	else if ([statistics tourRight] && [self.tableView visibleCells].count > 0)
		[self setupTour:UIPositionRight];
	else
		[self setupTour:0];
}

- (void)setupTour:(NSUInteger)position {
	if (UIPositionHorizontal(position)) {
		SwipeableCell *cell = [[self.tableView visibleCells] lastObject];
		if (!cell.textLabel.enabled)
			cell = [[self.tableView visibleCells] firstObject];
		if (cell.isSwiping)
			[cell endSwipe:^(BOOL finished) {
				[cell beginSwipe:position == UIPositionLeft];
			}];
		else
			[cell beginSwipe:position == UIPositionLeft];
		
		HelpView *help = [[HelpView alloc] initWithFrame:self.view.window.bounds position:position rect:cell.frame];
		[self.view.window addSubview:help];
		
		__weak HelpView *__help = help;
		[help show:^{
			[__help removeFromSuperview];
			
//			[cell endSwipe];
		}];
	} else if (UIPositionVertical(position)) {
		CGPoint offset = self.tableView.contentOffset;
		
		HelpView *help = [[HelpView alloc] initWithFrame:self.view.window.bounds position:position rect:CGRectNull];
		[self.view.window addSubview:help];
		
		__weak HelpView *__help = help;
		__weak UITableView *__table = self.tableView;
		[help show:^{
			[__help removeFromSuperview];
			
			[__table setContentOffset:offset animated:YES];
		}];
		
		[self.tableView setContentOffset:CGPointMake(0.0, position == UIPositionBottom ? 128.0 : -128.0) animated:YES];
	} else {
		[[self.view.window.subviews first:^BOOL(id item) {
			return [item isKindOfClass:[HelpView class]];
		}] removeFromSuperview];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	[[self.view.window.subviews first:^BOOL(id item) {
		return [item isKindOfClass:[HelpView class]];
	}] setFrame:self.view.window.bounds];
}

- (BOOL)helpVisible {
	return [self.view.window.subviews any:^BOOL(id item) {
		return [item isKindOfClass:[HelpView class]];
	}];
}

@end
