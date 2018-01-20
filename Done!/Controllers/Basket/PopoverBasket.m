//
//  PopoverBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 21.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Constants.h"
#import "FolderController.h"
#import "NSObject+Cast.h"
#import "PopoverBasket.h"
#import "UIApplication+ViewController.h"
#import "UIHelper.h"
#import "UIPopoverController+Convenience.h"
#import "UIViewController+Hierarchy.h"

@interface PopoverBasket ()
@property (strong, nonatomic) UIViewController *contentViewController;
@end

@implementation PopoverBasket

- (void)popover:(UIViewController *)vc inView:(UIView *)view withDelegate:(id<UIPopoverControllerDelegate>)delegate {
	self.contentViewController = vc;
	
	self.popover = [UIPopoverController create:vc withDelegate:delegate];
	[self.popover setPopoverContentSize:CGSizeMake(400.0, 600.0)];
	[self presentPopover:self.popover from:view animated:YES];
	
	self.contentViewController = Nil;
}

- (void)dismissViewController:(BOOL)animated {
	if (self.popover)
		[self.popover dismissPopoverAnimated:animated];
	else
		[super dismissViewController:animated];
}

- (void)presentViewController:(UIViewController *)viewController fromView:(UIView *)view {
	if ([UIHelper iPhone:self] || ((!view  && [viewController isKindOfClass:[BasketController class]]) || ([viewController isKindOfClass:[UIAlertController class]] && ((UIAlertController *)viewController).preferredStyle == UIAlertControllerStyleAlert)))
		[super presentViewController:viewController fromView:view];
	else
		[self popover:viewController inView:view withDelegate:self];
}

- (void)performSegue:(NSString *)identifier fromView:(UIView *)view {
	if ([UIHelper iPhone:self] || [identifier isEqualToString:GUI_LOGGER])
		[super performSegue:identifier fromView:view];
	else
		[self popover:[[self storyboard] instantiateViewControllerWithIdentifier:identifier] inView:view withDelegate:self];
}

- (void)dismissAll:(BOOL)animated {
	UIViewController *vc = self.presentedViewController;
	
	if (vc || self.popover) {
		[self dismissViewController:animated];
		
		if ([vc isKindOfClass:[FolderController class]])
			[self doneProcess:vc];
		else
			[self cancelProcess];
	} else {
		[self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:animated];
	}
	
	[super dismissSwipe];
}

- (void)didLoadPopover:(UIViewController *)controller {
	[self prepareProcess:controller];
}

- (void)shouldDismissPopover:(UIViewController *)controller {
	[self.popover dismissPopoverAnimated:YES];
	
	if (controller)
		[self doneProcess:controller];
	else
		[self cancelProcess];
	
	self.popover = Nil;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	if ([popoverController.contentViewController isKindOfClass:[FolderController class]])
		[self doneProcess:popoverController.contentViewController];
	else
		[self cancelProcess];
	
	self.popover = Nil;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (self.popover && motion == UIEventSubtypeMotionShake)
		[self shouldDismissPopover:Nil];
	else
		[super motionEnded:motion withEvent:event];
}

+ (BOOL)isPopover:(UIViewController *)controller {
	PopoverBasket *basket = [controller.presentingViewController ? controller.presentingViewController : [[UIApplication sharedApplication] rootViewController] as:[PopoverBasket class]];

	return [basket.contentViewController endpointViewController] == controller || [basket.popover.contentViewController endpointViewController] == controller;
}

@end
