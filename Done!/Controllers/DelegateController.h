//
//  DelegateController.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 23.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>

@interface DelegateController : ABPeoplePickerNavigationController <ABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate>

+ (NSInteger)getID:(UIViewController *)controller;
+ (NSString *)getName:(UIViewController *)controller;

@property (copy, nonatomic) void(^completion)(DelegateController *sender, BOOL success);

@end
