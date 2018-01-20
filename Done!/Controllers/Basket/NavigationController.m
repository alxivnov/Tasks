//
//  NavigationController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 06.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NavigationController.h"
#import "NSObject+Cast.h"
#import "Sounds.h"
#import "UIPinchGestureRecognizer+Scale.h"
#import "UIViewController+Transition.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)pinch:(UIPinchGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan && [sender pinchIn])
		[self dismiss:self];
}

- (void)dismiss:(id <UIPinchTransitionDelegate>)delegate {
	if (delegate) {
		[self dismissViewControllerWithTransition:[UIPinchTransition interactivePinchIn:delegate]];
	} else {
		[[self.presentingViewController as:[PannableBasket class]] dismissViewController:YES];
		
		[Sounds navigation];
	}
}

- (void)transitionWillFinish:(UIPinchTransition *)sender {
	[Sounds navigation];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		if (self.actionSheet || self.popover || [self.presentedViewController isKindOfClass:[UIAlertController class]] || [self.presentedViewController isKindOfClass:[UIActivityViewController class]])
			[super motionEnded:motion withEvent:event];
		else if (self.table.isUnfocused)
			[self dismiss:Nil];
	}
}

@end
