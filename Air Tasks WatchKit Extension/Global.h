//
//  Workflow.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 01.04.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "List.h"

#define GLOBAL [Global instance]

@interface Global : NSObject

+ (instancetype)instance;

@property (strong, nonatomic, readonly) List *list;

- (void)setListFromArray:(NSArray *)array;

@end
