//
//  DelegateController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 23.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "ABHelper.h"
#import "DelegateController.h"
#import "UIViewController+Hierarchy.h"

@interface DelegateController ()
@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSString *name;
@end

@implementation DelegateController

+ (NSInteger)getID:(UIViewController *)controller {
	return [controller isKindOfClass:[DelegateController class]] ? ((DelegateController *)controller).ID : NSNotFound;
}

+ (NSString *)getName:(UIViewController *)controller {
	return [controller isKindOfClass:[DelegateController class]] ? ((DelegateController *)controller).name : Nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.peoplePickerDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
	self.ID = [ABHelper getRecordID:person];
	self.name = [ABHelper getCompositeName:person];
	
	__weak DelegateController *__self = self;
	if (self.completion)
		self.completion(__self, YES);
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	self.ID = NSNotFound;
	self.name = Nil;

	__weak DelegateController *__self = self;
	if (self.completion)
		self.completion(__self, NO);
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	[self peoplePickerNavigationController:peoplePicker didSelectPerson:person];
	
	return NO;
}

@end
