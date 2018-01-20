//
//  Action+Activity.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 13.10.15.
//  Copyright © 2015 Alex Ivanov. All rights reserved.
//

#import "Action+Activity.h"
#import "Action+Folder.h"
#import "Action+Repeat.h"
#import "AlertHelper.h"
#import "Constants.h"
#import "Images.h"

#import "NSDate+Calculation.h"
#import "NSError+Log.h"
#import "NSHelper.h"
#import "UIImageCache.h"

#define IMG_DEFERRAL @"watch-deferral@2x"
#define IMG_CALENDAR @"watch-calendar@2x"
#define EXT_PNG @"png"

@import MobileCoreServices;

@implementation Action (Activity)

- (CSSearchableItem *)searchableItem {
	if ((self.state != GTD_ACTION_STATE_DEFERRAL && self.state != GTD_ACTION_STATE_CALENDAR) || ![self.date isGreaterThanOrEqual:[AlertHelper today]])
		return Nil;

	NSURL *imageURL = [[NSBundle mainBundle] URLForResource:self.state == GTD_ACTION_STATE_DEFERRAL ? IMG_DEFERRAL : IMG_CALENDAR withExtension:EXT_PNG];

	CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeText];
	attributes.title = [self folderDescription];
	attributes.contentDescription = [self repeatDateDescription];
	attributes.thumbnailURL = imageURL;
	attributes.keywords = @[ @"air", @"tasks" ];
//	attributes.URL = Nil;
	CSSearchableItem *searchableItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:self.uuid domainIdentifier:STR_TASK attributeSet:attributes];
	searchableItem.expirationDate = self.state == GTD_ACTION_STATE_DEFERRAL ? [self.date addValue:1 forComponent:NSCalendarUnitDay] : self.date;

	return searchableItem;
}

- (void)indexSearchableItem {
	[NSHelper dispatchToGlobal:^{
		[[CSSearchableIndex defaultSearchableIndex] reindexSearchableItem:[self searchableItem]];
	}];
}

- (void)deleteSearchableItem {
	[NSHelper dispatchToGlobal:^{
		[[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifier:self.uuid];
	}];
}

@end
