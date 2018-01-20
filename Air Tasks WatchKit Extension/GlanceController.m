//
//  GlanceController.m
//  Air Tasks WatchKit Extension
//
//  Created by Alexander Ivanov on 28.03.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "GlanceController.h"
#import "List.h"

#import "NSHelper.h"
#import "WCSessionDelegate.h"


@interface GlanceController()
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *numberGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *numberLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *stringLabel;
@end


@implementation GlanceController

- (void)setup:(NSNumber *)number :(NSString *)string {
	[self.numberGroup setBackgroundImageNamed:!number || number.unsignedIntegerValue ? @"glance-background-128" : @"glance-background-done-128"];
	[self.numberLabel setText:number.unsignedIntegerValue ? [number description] : Nil];
	[self.stringLabel setText:[string stringByReplacingOccurrencesOfString:STR_NEW_LINE withString:STR_SPACE]];
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
	
	[self setup:Nil :Nil];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
	
	[[WCSessionDelegate instance].session sendMessage:@{ EXT_ACTION_KEY : EXT_ACTION_STATISTICS_KEY } replyHandler:^(NSDictionary *replyInfo) {
		[self setup:replyInfo[EXT_NUMBER_KEY] :replyInfo[EXT_STRING_KEY]];
	}];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



