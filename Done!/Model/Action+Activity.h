//
//  Action+Activity.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 13.10.15.
//  Copyright © 2015 Alex Ivanov. All rights reserved.
//

#import "Action.h"

#import "CSSearchableIndex+Convenience.h"

@interface Action (Activity)

- (CSSearchableItem *)searchableItem;

- (void)indexSearchableItem;
- (void)deleteSearchableItem;

@end
