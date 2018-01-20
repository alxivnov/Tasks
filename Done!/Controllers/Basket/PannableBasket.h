//
//  PannableBasketController.h
//  Done!
//
//  Created by Alexander Ivanov on 13.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import	"OrderableBasket.h"
#import "EnterableCell.h"
#import "UIViewController+Popover.h"

#define ALERT_DO 100
#define ALERT_UNDO 200
#define ALERT_MOVE 300

@interface PannableBasket : OrderableBasket <UIActionSheetDelegate, EnterableCellDelegate, PannableCellDelegate>

@property (strong, nonatomic) UIActionSheet *actionSheet;

- (void)dismissViewController:(BOOL)animated;
- (void)presentViewController:(UIViewController *)viewController fromView:(UIView *)view;
- (void)performSegue:(NSString *)identifier fromView:(UIView *)view;

- (void)prepareProcess:(UIViewController *)viewController;
- (void)doneProcess:(UIViewController *)viewController;
- (void)cancelProcess;

- (void)action:(NSInteger)buttonIndex with:(NSIndexPath *)indexPath;
- (BOOL)process:(PannableCell *)sender;

@end
