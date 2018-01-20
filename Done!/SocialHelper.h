//
//  SLBasketViewController.h
//  Done!
//
//  Created by Alexander Ivanov on 13.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "SLHelper.h"

#define URL_APP_STORE @"https://itunes.apple.com/app/apple-store/id734258590?mt=8&uo=4&at=1l3voBu&pt=10603809&ct=Air%20Tasks"
#define URL_FACEBOOK @"https://www.facebook.com/groups/doneapp/"
#define URL_GOOGLE_PLUS @"https://plus.google.com/+AirtasksNetPlus"
#define URL_VKONTAKTE @"https://vk.com/airtasks"
#define URL_WEBSITE @"http://airtasks.net"

@interface SocialHelper : NSObject <SLHelperDelegate>

+ (void)compose:(UIViewController *)controller alert:(BOOL)alert;
+ (void)compose:(UIViewController *)controller;

+ (void)share:(UIViewController *)controller image:(UIImage *)image text:(NSString *)text;;
+ (UIPopoverController *)shareInPopover:(UIView *)view image:(UIImage *)image text:(NSString *)text;

+ (void)setupDefaultURLs;

@end
