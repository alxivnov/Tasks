//
//  HelpHelper.m
//  Done!
//
//  Created by Alexander Ivanov on 19.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "HelpHelper.h"
#import "Workflow.h"
#import "Sounds.h"
#import "Localization.h"
#import "LocalizationHelp.h"

#import "NSBundle+Convenience.h"
#import "NSHelper.h"

#define LINK_GUIDE @"http://airtasks.net/wp-content/uploads/2014/04/Done.-Guide.pdf"
#define LINK_GUIDE_REPEAT @"http://airtasks.net/wp-content/uploads/2014/04/Done.-Guide.-Repeating-Actions.pdf"
#define LINK_GUIDE_FOLDER @"http://airtasks.net/wp-content/uploads/2014/04/Done.-Guide.-Projects.pdf"
#define LINK_GUIDE_LOGGER @"http://airtasks.net/wp-content/uploads/2014/08/Done.-Guide.-Archive.pdf"
#define LINK_GUIDE_RU @"http://airtasks.net/wp-content/uploads/2014/07/Done.-Guide.-Ru.pdf"
#define LINK_GUIDE_REPEAT_RU @"http://airtasks.net/wp-content/uploads/2014/07/Done.-Guide.-Repeating-Actions.-Ru.pdf"
#define LINK_GUIDE_FOLDER_RU @"http://airtasks.net/wp-content/uploads/2014/07/Done.-Guide.-Projects.-Ru.pdf"
#define LINK_GUIDE_LOGGER_RU @"http://airtasks.net/wp-content/uploads/2014/08/Done.-Guide.-Archive.-Ru.pdf"

@implementation HelpHelper

+ (NSURL *)guideApplication {
	return [NSURL URLWithString:[NSBundle isPreferredLocalization:LNG_RU] ? LINK_GUIDE_RU : LINK_GUIDE];
}

+ (NSURL *)guidePurchaseRepeat {
	return [NSURL URLWithString:[NSBundle isPreferredLocalization:LNG_RU] ? LINK_GUIDE_REPEAT_RU : LINK_GUIDE_REPEAT];
}

+ (NSURL *)guidePurchaseFolder {
	return [NSURL URLWithString:[NSBundle isPreferredLocalization:LNG_RU] ? LINK_GUIDE_FOLDER_RU : LINK_GUIDE_FOLDER];
}

+ (NSURL *)guidePurchaseLogger {
	return [NSURL URLWithString:[NSBundle isPreferredLocalization:LNG_RU] ? LINK_GUIDE_LOGGER_RU : LINK_GUIDE_LOGGER];
}

static id _instance;

+ (instancetype)instance {
	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}
	
	return _instance;
}

+ (void)help:(UIViewController *)controller {
	[[self instance] help:controller];
}

- (void)help:(UIViewController *)controller {
	[[[UIAlertView alloc] initWithTitle:[LocalizationHelp help] message:Nil delegate:self cancelButtonTitle:[Localization cancel] otherButtonTitles:[LocalizationHelp application], [LocalizationHelp repeat], [LocalizationHelp folder], [LocalizationHelp logger], Nil] show];
	
	[Sounds endProcess];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = alertView.cancelButtonIndex == buttonIndex ? Nil : [alertView buttonTitleAtIndex:buttonIndex];
	
	if ([NSHelper string:[LocalizationHelp application] isEqualTo:buttonTitle])
		[[UIApplication sharedApplication] openURL:[[self class] guideApplication]];
	else if ([NSHelper string:[LocalizationHelp repeat] isEqualTo:buttonTitle])
		[[UIApplication sharedApplication] openURL:[[self class] guidePurchaseRepeat]];
	else if ([NSHelper string:[LocalizationHelp folder] isEqualTo:buttonTitle])
		[[UIApplication sharedApplication] openURL:[[self class] guidePurchaseFolder]];
	else if ([NSHelper string:[LocalizationHelp logger] isEqualTo:buttonTitle])
		[[UIApplication sharedApplication] openURL:[[self class] guidePurchaseLogger]];
}



@end
