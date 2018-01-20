//
//  SLBasketViewController.m
//  Done!
//
//  Created by Alexander Ivanov on 13.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "SocialHelper.h"
#import "Localization.h"
#import "LocalizationCompose.h"
#import "LocalizationRating.h"
#import "Sounds.h"
#import "StatisticsView.h"
#import "Workflow.h"

#import "NSHelper.h"
#import "UIHelper.h"
#import "UIRateController.h"
#import "UIViewController+Popover.h"
#import "UIWebActivityFacebook.h"
#import "UIWebActivityGooglePlus.h"
#import "UIWebActivityTwitter.h"
#import "UIWebActivityVK.h"

#define FACEBOOK_APP_ID @"319685018180994"

@interface SocialHelper ()
@property (assign, nonatomic) BOOL alert;
@end

@implementation SocialHelper

static id _instance;

+ (instancetype)instance {
	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}
	
	return _instance;
}

- (void)composeClickedButtonWithTitle:(NSString *)title {
	if (!self.alert)
		return;
	
	if (!title)
		[Workflow instance].statistics.cancel++;
	else if ([NSHelper string:title isEqualTo:[LocalizationCompose happy]])
		[Workflow instance].statistics.happy++;
	else if ([NSHelper string:title isEqualTo:[LocalizationCompose confused]])
		[Workflow instance].statistics.confused++;
	else if ([NSHelper string:title isEqualTo:[LocalizationCompose unhappy]])
		[Workflow instance].statistics.unhappy++;
	else if ([NSHelper string:title isEqualTo:APP_STORE])
		[Workflow instance].statistics.appStore = [NSDate date];
}

- (void)composeDone:(SLComposeViewController *)sender {
	// do nothing
}

- (void)composeCancelled:(SLComposeViewController *)sender {
	// do nothing
}

+ (void)compose:(UIViewController *)controller alert:(BOOL)alert {
	if (alert && IOS_8_0) {
		[RATE_CONTROLLER incrementAction];
		
		return;
	}
	
	CloudStatistics *statistics = [Workflow instance].statistics;
	NSUInteger done = [statistics calculateDone];
		
	((SocialHelper *)[self instance]).alert = alert;
	if (alert) {
		NSUInteger denominator = 100;
		while (done / 10 / denominator > 0)
			denominator *= 10;
		
		if (done == denominator)
			statistics.cancel = 0;
		
		if (done % denominator || statistics.cancel)
			return;
	}
	
	NSNumber *number = @(done);
	NSString *initialText = [NSString stringWithFormat:[LocalizationCompose text], number];
	UIImage *image = [StatisticsView snapshotWithNumber:[number description] andString:[Localization statisticsActionsDoneTotal]];
	[SLHelper composeWithTitle:[LocalizationRating title:done] presentingViewController:controller appStore:YES initialText:initialText image:image appStoreURL:[NSURL URLWithString:URL_APP_STORE] websiteURL:[NSURL URLWithString:URL_WEBSITE] email:EMAIL delegate:[self instance] alert:alert];
	
	[Sounds compose];


	if (alert)
		statistics.compose = [NSDate date];
}

+ (void)compose:(UIViewController *)controller {
	[self compose:controller alert:NO];
}

+ (UIViewController *)share:(UIImage *)image text:(NSString *)text {
	return [SLHelper composeWithServiceType:Nil initialText:text image:image url:[NSURL URLWithString:URL_APP_STORE] completion:Nil];
}

+ (void)share:(UIViewController *)controller image:(UIImage *)image text:(NSString *)text {
	[Workflow instance].statistics.share++;

	UIViewController *share = [self share:image text:text];

	[controller presentViewController:share animated:YES completion:Nil];

	[Sounds compose];
}

+ (UIPopoverController *)shareInPopover:(UIView *)view image:(UIImage *)image text:(NSString *)text {
	[Workflow instance].statistics.share++;

	UIViewController *share = [self share:image text:text];

	UIPopoverController *popover = [share popoverInView:view withDelegate:Nil animated:YES];

	[Sounds compose];

	return popover;
}

+ (void)setupDefaultURLs {
	[UIWebActivityFacebook setDefaultURL:[NSURL URLWithString:URL_FACEBOOK]];
	[UIWebActivityGooglePlus setDefaultURL:[NSURL URLWithString:URL_GOOGLE_PLUS]];
	[UIWebActivityTwitter setDefaultURL:[NSURL URLWithString:URL_WEBSITE]];
	[UIWebActivityVK setDefaultURL:[NSURL URLWithString:URL_VKONTAKTE]];
	
	NSArray *hashtags = ARRAY(HASHTAG);
	[UIWebActivityFacebook setHashtags:hashtags];
	[UIWebActivityGooglePlus setHashtags:hashtags];
	[UIWebActivityTwitter setHashtags:hashtags];
	[UIWebActivityVK setHashtags:hashtags];

	[UIWebActivityFacebook setAppID:FACEBOOK_APP_ID];
}

@end
