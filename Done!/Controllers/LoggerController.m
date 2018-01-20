//
//  LoggerController.m
//  Done!
//
//  Created by Alexander Ivanov on 08.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ADClient+Convenience.h"
#import "Basket.h"
#import "Basket+Process.h"
#import "Constants.h"
#import "CustomBasket.h"
#import "Images.h"
#import "Localization.h"
#import "LocalizationPurchase.h"
#import "LocalizationHelp.h"
#import "LoggerController.h"
#import "NSDate+Description.h"
#import "NSHelper.h"
#import "NSObject+Cast.h"
#import "Palette.h"
#import "Sounds.h"
#import "SKReceiptObserver.h"
#import "UIApplication+ViewController.h"
#import "UIHelper.h"
#import "UITableView+Rows.h"
#import "UIViewController+Alert.h"
#import "UIViewController+Purchase.h"
#import "Workflow.h"

@import iAd;

@interface LoggerController ()
@property (strong, nonatomic) Basket *basket;

@property (strong, nonatomic) SKInAppPurchase *purchase;
@end

@implementation LoggerController

- (SKInAppPurchase *)purchase {
	if (!_purchase)
		_purchase = [APP_RECEIPT purchaseByIdentifier:[Constants inAppPurchaseLogger]];
	
	return _purchase;
}

- (Basket *)basket {
	if (!_basket)
		_basket = [Workflow logger];
	
	return _basket;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.basket filteredCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GUI_CELL_ID forIndexPath:indexPath];
	
	Action *action = [self.basket filteredIndex:indexPath.row];
	
	cell.textLabel.text = action.title;
	cell.detailTextLabel.text = [action.changed descriptionForDateAndTime:NSDateFormatterShortStyle];
	
	switch (action.state) {
		case GTD_ACTION_STATE_DEFERRAL:
			cell.imageView.image = [Images deferralLine];
			cell.imageView.tintColor = [Palette yellow];
			break;
		case GTD_ACTION_STATE_CALENDAR:
			cell.imageView.image = [Images calendarLine];
			cell.imageView.tintColor = [Palette red];
			break;
		case GTD_ACTION_STATE_DELEGATE:
			cell.imageView.image = [Images delegateLine];
			cell.imageView.tintColor = [Palette blue];
			break;
		default:
			cell.imageView.image = Nil;
			cell.imageView.tintColor = Nil;
			break;
	}
	
	cell.accessoryType = action.folder ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		Action *action = [self.basket filteredIndex:indexPath.row];
		
		LoggerController *vc = [self.storyboard instantiateViewControllerWithIdentifier:GUI_LOGGER];
		vc.navigationItem.title = action.title;
		vc.basket = action.folderValues;
		[self.navigationController pushViewController:vc animated:YES];
	}
	
	[tableView selectRowAtIndexPath:Nil animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (!self.purchase.purchased)
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			if ([self.basket removeAt:indexPath.row])
				[tableView deleteRowAtIndexPath:indexPath withAnimation:UITableViewRowAnimationAutomatic];
			
			[self.basket save];
		}
}

- (void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (self.purchase.purchased) {
		Action *original = [self.basket filteredIndex:indexPath.row];
		
		Action *action = Nil;
		if (original.parent.parent) {
			action = [original.parent.parent clone:NO];
			[action.folderValues add:[original clone:YES]];
		} else {
			action = [original clone:YES];
		}
		
		Basket *basket = [Workflow instance].basket;
		if ([basket merge:action at:0] == NSNotFound)
			[basket sortRowAt:0];
		[basket save];
//	}
	
	[tableView setEditing:NO animated:YES];
//	[tableView reloadRowAtIndexPath:indexPath withAnimation:UITableViewRowAnimationAutomatic];
}

- (NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath;{
	return [Localization restore];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	if ([self.basket.filter isEqualToString:searchString])
		return NO;
	
	self.basket.filter = searchString;
	
	return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
	self.basket.filter = Nil;
	
	self.searchDisplayController.searchResultsTableView.editing = NO;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (self.basket.parent)
		return;
	
	self.navigationItem.title = [LocalizationHelp logger];
	
	[Workflow instance].statistics.beginLogger++;
/*
	if (self.purchase.purchased) {

	} else {
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[LocalizationPurchase purchase] style:UIBarButtonItemStyleDone target:self action:@selector(purchase:)];
		self.navigationItem.leftBarButtonItem.enabled = NO;
	}
*/
	self.canDisplayBannerAds = IS_DEBUGGING || !self.purchase.purchased;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!self.purchase.purchased) {
		if ([Workflow instance].statistics.beginLogger > 10 && [Workflow instance].statistics.beginLogger % GUI_PURCHASE_FREQUENCY == 1)
			[self purchase:Nil];
//		else
//			self.navigationItem.leftBarButtonItem.enabled = YES;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([UIHelper iPhone:self] && scrollView.isDragging && scrollView.contentOffset.y < scrollView.bounds.size.height / -3.0)
		[self performSegueWithIdentifier:GUI_CANCEL sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:GUI_CANCEL]) {
		[[self.presentingViewController as:[CustomBasket class]] reloadTableView:YES];
		
		[Workflow instance].statistics.endLogger++;
		
		self.purchase.productRequestHandler = Nil;
		self.purchase.paymentRequestHandler = Nil;
	}
}

- (IBAction)purchase:(UIBarButtonItem *)sender {
//	self.navigationItem.leftBarButtonItem.enabled = NO;

	NSString *message =[STR_NEW_LINE/*@"• • •\n$description\n• • •\n"*/ stringByAppendingString:[NSString stringWithFormat:[LocalizationPurchase message], @"$price"]];
	__weak LoggerController *__self = self;
	[self presentPurchase:self.purchase title:[LocalizationPurchase title] message:message cancelButtonTitle:[Localization later] purchaseButtonTitle:[LocalizationPurchase purchase] completion:^(BOOL success, NSError *error) {
		if (success)
			__self.navigationItem.leftBarButtonItem = Nil;
		else
			__self.navigationItem.leftBarButtonItem.enabled = YES;
		
		[__self presentAlertWithError:error cancelButtonTitle:[Localization cancel]];
		
		self.canDisplayBannerAds = !success;
		
		if (success)
			[[ADClient sharedClient] addClientToSegment:SEG_PAYED replaceExisting:NO];
	}];
	
	[[ADClient sharedClient] addClientToSegment:SEG_DID_NOT_PAY replaceExisting:NO];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventTypeMotion)
		[self performSegueWithIdentifier:GUI_CANCEL sender:self];
}

@end
