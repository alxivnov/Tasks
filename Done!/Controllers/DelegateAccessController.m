//
//  DelegateAccessController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 24.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "ABHelper.h"
#import "DelegateAccessController.h"
#import "UIScrollView+Scroll.h"

@interface DelegateAccessController ()

@end

@implementation DelegateAccessController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self.tableView setContentInsetTop:self.tableView.contentInset.top + self.navigationController.navigationBar.frame.size.height + [UIHelper statusBarHeight]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[ABHelper requestAuthorization:^(bool granted, CFErrorRef error) {
		__weak DelegateAccessController *__self = self;
		if (self.completion)
			self.completion(__self, granted);
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
