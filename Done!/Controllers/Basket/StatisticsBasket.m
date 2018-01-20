//
//  StatisticsBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 12.05.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Basket+Query.h"
//#import "CFFTPUpload.h"
#import "ColorScheme.h"
#import "Constants.h"
#import "Localization.h"
#import "NSDate+Calculation.h"
#import "NSDate+Description.h"
#import "NSHelper.h"
#import "NSRandom.h"
#import "Sounds.h"
#import "StatisticsBasket.h"
#import "Workflow.h"

@interface StatisticsBasket ()
@property (strong, nonatomic, readwrite) StatisticsView *statisticsView;

@property (strong, nonatomic) NSRandom *random;

//@property (strong, nonatomic) CFFTPUpload *ftp;
@end

@implementation StatisticsBasket

- (CGRect)statisticsFrame {
	return CGRectMake(0, 0, self.background.bounds.size.width, STATISTICS_IMAGE_SIZE);
}

- (UIView *)statisticsView {
	if (!_statisticsView) {
		_statisticsView = [[StatisticsView alloc] initWithFrame:[self statisticsFrame]];
		_statisticsView.color = [ColorScheme instance].lightGrayColor;
		_statisticsView.hidden = YES;
		_statisticsView.opaque = YES;
		
		[self.background addSubview:_statisticsView];
	}
	
	return _statisticsView;
}

- (NSRandom *)random {
	if (!_random)
		_random = [[NSRandom alloc] initWithIndex:0 andCount:5];
	
	return _random;
}

- (void)hideStatistics {
	if (self.statisticsView.hidden)
		return;
	
	self.statisticsView.hidden = YES;
	
	[self.statisticsView setArrowForDirection:0];
}

- (void)showStatistics:(BOOL)show withState:(ScrollState)state {
	if (!self.statisticsView.hidden)
		return;
	
	[self setStatisticsFrame];
	
	if (show)
		switch ([self.random generate:YES]) {
			case 0: {
				NSUInteger count = [self.basket count];
				[self.statisticsView setNumber:@(count) andString:[Localization statisticsActionsInList]];
				break;
			}
			case 1: {
				NSUInteger count = [[Workflow instance].basket rangeWhereDateIsEqualTo:[[NSDate date] dateComponent]].length;
				[self.statisticsView setNumber:@(count) andString:[Localization statisticsActionsForToday]];
				break;
			}
			case 2: {
				NSUInteger done = self.basket.parent ? self.basket.parent.folderCount : [self.statistics calculateDone];
				[self.statisticsView setNumber:@(done) andString:[Localization statisticsActionsDoneTotal]];
				break;
			}
			case 3: {
				NSUInteger days = [(self.basket.parent ? self.basket.parent.created : [self.statistics calculateFirstLaunch]) daysToNow];
				[self.statisticsView setNumber:@(days) andString:[Localization statisticsDaysPassedTotal]];
				break;
			}
			case 4: {
				NSUInteger days = [(self.basket.parent ? self.basket.parent.created : [self.statistics calculateFirstLaunch]) daysToNow];
				NSUInteger done = self.basket.parent ? self.basket.parent.folderCount : [self.statistics calculateDone];
				done = done / (days > 0 ? days : 1);
				[self.statisticsView setNumber:@(done) andString:[Localization statisticsActionsDonePerDay]];
				break;
			}
		}
	else
		[self.statisticsView setNumber:Nil andString:Nil];
	
	self.statisticsView.hidden = NO;
	
	[self.statisticsView setArrowForDirection:!self.onboarding ? state > ScrollZero ? UIDirectionDown : state < ScrollZero ? UIDirectionUp : 0 : 0];
}

- (void)setStatisticsFrame {
	if (self.statisticsView.frame.size.width != self.background.bounds.size.width)
		self.statisticsView.frame = [self statisticsFrame];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	[self setStatisticsFrame];
}
/*
- (void)upload {
	NSDate *now = [NSDate date];
	
	if (!self.settings.statisticsUpload || [[now addDays:-10] isLessThanOrEqual:self.statistics.upload])
		return;
	
	NSString *url = [NSString stringWithFormat:@"%@/%@-%@.xml", FTP_URL, [now filenameDescription], self.statistics.unique];
	self.ftp = [CFFTPUpload uploadFile:@"Statistics.plist" toURL:url withUsername:FTP_USERNAME andPassword:FTP_PASSWORD completion:^(BOOL success) {
		if (success)
			self.statistics.upload = now;
	}];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (self.count > 1)
		return;
	
//	[DSHelper dispatchToGlobal:^{
//		[self upload];
//	}];
}
*/
- (BOOL)updateColorScheme {
	if (![super updateColorScheme])
		return NO;

	self.statisticsView.color = [ColorScheme instance].lightGrayColor;
	
	return YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self updateColorScheme];
}
@end
