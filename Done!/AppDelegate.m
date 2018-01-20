//
//  AppDelegate.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "AppDelegate.h"
#import "Constants.h"
#import "InBasketController.h"
#import "PurchaseStatistics+Purchase.h"
#import "WatchDelegate.h"
#import "Workflow.h"

#import "GSTouchesShowingWindow.h"
#import "NSError+Log.h"
#import "NSHelper.h"
#import "NSLocalFileDataSource.h"
#import "NSURL+File.h"
#import "SKInAppPurchase.h"
#import "SKReceipt.h"
#import "SKReceiptObserver.h"
#import "UIApplication+ViewController.h"
#import "UIHelper.h"
#import "UIViewController+Hierarchy.h"

@implementation AppDelegate
/*
- (GSTouchesShowingWindow *)window {
	static GSTouchesShowingWindow *window = Nil;
	if (!window) {
		window = [[GSTouchesShowingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	}
	return window;
}
*/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	
	[[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
	
//	[NotificationHelper request];
	
	InBasketController *vc = AS(InBasketController, [[UIApplication sharedApplication] rootViewController]);
	
	[Workflow instance].delegate = vc;
	
	APP_RECEIPT.delegate = vc;
	[APP_RECEIPT fetchPurchases:@[ [Constants inAppPurchaseFolder], [Constants inAppPurchaseRepeat], [Constants inAppPurchaseLogger] ]];
	
	NSURL *url = Nil;
//	NSLocalFileDataSource *dataSource = [NSLocalFileDataSource create:APP_GROUP];
//	NSString *key = [[Statistics class] description];
//	NSURL *url = [dataSource urlFromKey:key];
	if ([url isExistingFile] && [[Workflow instance].statistics hasPurchases]) {
		[NSHelper dispatchToGlobal:^{
			SKReceipt *receipt = [[SKReceipt alloc] init];
			if (![receipt validateReceiptWithIdentifier:[Constants appBundleIdentifier] andVersion:Nil] || ![receipt checkExpirationDate])
				[[SKReceiptObserver instance] refreshReceipt];
		}];
	}
	
	[Fabric with:@[ [Crashlytics class] ]];
	
	if (!IOS_8_0) {
		UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
		[AS(InBasketController, [[UIApplication sharedApplication] rootViewController]) didReceiveLocalNotification:notification withAction:Nil];
	}
	
	[[WatchDelegate instance] session];
	
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//	[[[[UIApplication sharedApplication] rootViewController] as:[InBasketController class]] updateTourPrompt];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	[AS(InBasketController, [[UIApplication sharedApplication] rootViewController]) didReceiveLocalNotification:notification withAction:Nil];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
	[AS(InBasketController, [[UIApplication sharedApplication] rootViewController]) didReceiveLocalNotification:notification withAction:identifier];
	
	completionHandler();
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {	
	[AS(InBasketController, [[UIApplication sharedApplication] rootViewController]) openFile:url];
	
	return YES;
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[AS(InBasketController, [[UIApplication sharedApplication] rootViewController]) significantTimeChange];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	[NSHelper dispatchToGlobal:^{
		if ([Workflow fetch])
			completionHandler(UIBackgroundFetchResultNewData);
		else
			completionHandler(UIBackgroundFetchResultNoData);
	}];
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
	[[WatchDelegate instance] session:[WatchDelegate instance].session didReceiveMessage:userInfo replyHandler:reply];
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
	return [[[[application rootViewController] endpointViewController:YES] performSelector:@selector(application:willContinueUserActivityWithType:) withObject:application withObject:userActivityType recursion:UIRecursionBreak] boolValue];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
	return [[[application rootViewController] performSelector:@selector(application:continueUserActivity:restorationHandler:) withObject:application withObject:userActivity withObject:restorationHandler recursion:UIRecursionBreak] boolValue];
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
	[error log:@"didFailToContinueUserActivityWithType:"];
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	
	[AS(InBasketController, [[UIApplication sharedApplication] rootViewController]) didBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
