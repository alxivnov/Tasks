//
//  Action+Compare.h
//  Done!
//
//  Created by Alexander Ivanov on 04.12.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Action.h"

@interface Action (Compare)

- (NSComparisonResult)compareByTtile:(Action *)action;
- (NSComparisonResult)compareByStateTo:(Action *)action;
- (NSComparisonResult)compareByStateWith:(Action *)action;
- (NSComparisonResult)compareByOwner:(Action *)action;
- (NSComparisonResult)compareByDate:(Action *)action;
- (NSComparisonResult)compare:(Action *)action;
- (NSComparisonResult)compareByKind:(Action *)action;

- (NSComparisonResult)periodize;

@end
