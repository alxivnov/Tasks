//
//  FolderController.m
//  Done!
//
//  Created by Alexander Ivanov on 23.03.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ADClient+Convenience.h"
#import "CloudStatistics+Help.h"
#import "Constants.h"
#import "CustomBasket+Hint.h"
#import "FolderController.h"
#import "HelpHelper.h"
#import "Images.h"
#import "Localization.h"
#import "LocalizationPurchase.h"
#import "NSHelper.h"
#import "NSObject+Cast.h"
#import "Palette.h"
#import "PaletteEx.h"
#import "SKReceiptObserver.h"
#import "UIApplication+ViewController.h"
#import "UIHelper.h"
#import "UIPinchTransition.h"
#import "UIViewController+Alert.h"
#import "UIViewController+Hierarchy.h"
#import "UIViewController+Purchase.h"
#import "UIViewController+Transition.h"

@import iAd;

@interface FolderController ()
@property (strong, nonatomic) NSString *folderTitle;

@property (strong, nonatomic) SKInAppPurchase *purchase;

//@property (assign, nonatomic) BOOL purchaseEnabled;
@end

@implementation FolderController

- (SKInAppPurchase *)purchase {
	if (!_purchase)
		_purchase = [APP_RECEIPT purchaseByIdentifier:[Constants inAppPurchaseFolder]];
	
	return _purchase;
}

+ (Basket *)getValues:(UIViewController *)controller {
	FolderController *vc = [FolderController viewController:controller];
	return vc.basket;
}

+ (void)setValues:(Basket *)basket andTitle:(NSString *)title forViewController:(UIViewController *)controller {
	FolderController *vc = [FolderController viewController:controller];
	vc.basket = basket;
	vc.folderTitle = title;
}

- (BOOL)hideStatusBarOnScrollDown {
	return ![PopoverBasket isPopover:self];
}

- (BOOL)hideStatusBarOnScrollUp {
	return ![PopoverBasket isPopover:self];
}

- (CGFloat)topInset {
	return ![PopoverBasket isPopover:self] ? [super topInset] : 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	if (![PopoverBasket isPopover:self])
		return cell;
	
	cell.backgroundColor = [Palette white];
	cell.textLabel.textColor = [Palette black];
	cell.detailTextLabel.textColor = [Palette black];
	
	return cell;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if ([PopoverBasket isPopover:self]) {
		self.tableView.backgroundColor = [Palette white];
		self.statisticsView.color = [Palette lightGray];
	} else {
		[self.statisticsView setDetail:self.folderTitle];
	}
/*
	if (self.purchase.purchased)
		self.purchaseEnabled = YES;
	else
		self.purchaseEnabled = NO;
*/
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIViewController *vc = [PopoverBasket isPopover:self] ? [[UIApplication sharedApplication] rootViewController] : self;
	vc.canDisplayBannerAds = IS_DEBUGGING || !self.purchase.purchased;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!self.purchase.purchased) {
		if (self.statistics.beginFolder > 10 && self.statistics.beginFolder % GUI_PURCHASE_FREQUENCY == 1)
			[self buy];
//		else
//			self.purchaseEnabled = YES;
	}
	
	if ([self.tableView visibleCells].count > 0)
		return;
	
	[self hint:[Localization emptyFolder]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if (self.actionSheet)
		[self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	self.purchase.productRequestHandler = Nil;
	self.purchase.paymentRequestHandler = Nil;
	
	[[UIApplication sharedApplication] rootViewController].canDisplayBannerAds = NO;
}

- (void)buy {
//	self.purchaseEnabled = NO;
	
	NSString *message =[STR_NEW_LINE/*@"• • •\n$description\n• • •\n"*/ stringByAppendingString:[NSString stringWithFormat:[LocalizationPurchase message], @"$price"]];
	__weak FolderController *__self = self;
	[self presentPurchase:self.purchase title:[LocalizationPurchase title] message:message cancelButtonTitle:[Localization later] purchaseButtonTitle:[LocalizationPurchase purchase] completion:^(BOOL success, NSError *error) {
//		__self.purchaseEnabled = YES;
		
		[__self presentAlertWithError:error cancelButtonTitle:[Localization cancel]];
		
		__self.canDisplayBannerAds = !success;
		
		if (success)
			[[ADClient sharedClient] addClientToSegment:SEG_PAYED replaceExisting:NO];
	}];
	
	[[ADClient sharedClient] addClientToSegment:SEG_DID_NOT_PAY replaceExisting:NO];
}
/*
- (void)add {
	if (!self.purchaseEnabled)
		return;
	
	if (self.purchase.purchased) {
		[super add];
	} else {
		[self buy];
	}
}
*/
- (void)clearWithState:(ScrollState)state {
	if (state == ScrollUpL) {
		self.statistics.dismissFolder++;
		
		[self dismiss:Nil];
	} else {
		[super clearWithState:state];
	}
}

- (void)showStatistics:(BOOL)show withState:(ScrollState)state {
	[super showStatistics:show withState:(state > ScrollZero && [self.statistics hintTop]) || (state < ScrollZero && [self.statistics hintBottom:YES]) ? state : 0];
}

- (void)setImageForState:(ScrollState)state {
	if (state == ScrollUpL)
		[self.statisticsView setImage:[Images backFull] andColor:[Palette violet]];
	else// if (state < ScrollZero || self.purchase.purchased)
		[super setImageForState:state];
/*	else if (state == ScrollDownS)
		[self.statisticsView setImage:[Images purchaseLine] andColor:self.purchaseEnabled ? [PaletteEx iosBlue] : [PaletteEx iosGray]];
	else
		[self.statisticsView setImage:[Images purchaseFull] andColor:self.purchaseEnabled ? [Palette iosBlue] : [Palette iosGray]];
*/}

- (void)dismiss:(id <UIPinchTransitionDelegate>)delegate {
	if ([self.presentingViewController isKindOfClass:[PannableBasket class]])
		[((PannableBasket *)self.presentingViewController) doneProcess:self];
	
	[super dismiss:delegate];
}

@end
