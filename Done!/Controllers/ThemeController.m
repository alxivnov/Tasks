//
//  ThemeController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 08.08.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "ThemeController.h"
#import "Workflow.h"
#import "LocalizationSettings.h"

#import "UITableView+Rows.h"

@implementation ThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellForIndexPath:indexPath];

	cell.textLabel.text = [LocalizationSettings theme:indexPath.row];
	cell.accessoryType = indexPath.row == GLOBAL.settings.theme ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	for (NSIndexPath *item in [tableView indexPathsForVisibleRows])
		[tableView cellForRowAtIndexPath:item].accessoryType = [item isEqualToIndexPath:indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	GLOBAL.settings.theme = indexPath.row;
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
