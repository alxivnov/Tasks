//
//  DelegateAccessController.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 24.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelegateAccessController : UITableViewController <UISearchDisplayDelegate>

@property (copy, nonatomic) void(^completion)(DelegateAccessController *sender, BOOL success);

@end
