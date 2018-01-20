//
//  Basket.h
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Action.h"
#import "NSPropertyArray.h"

typedef NS_OPTIONS(NSUInteger, BASKET_MODE) {
	SINGLE_FILE = 0,
	DISTRIBUTED = (1 << 1),
	DISTRIBUTED_LAZY = (1 << 2),
};

@class Action;

@protocol BasketDelegate <NSObject>

- (void)willChangeExternally:(NSNotification *)notification;
- (void)didChangeExternally:(NSNotification *)notification;

@end

@interface Basket : NSPropertyArray

@property (assign, nonatomic) BASKET_MODE mode;

@property (weak, nonatomic) Action *parent;

- (instancetype)initWithParent:(Action *)parent;

- (void)add:(Action *)action;
- (void)addRange:(NSArray *)array;
- (BOOL)add:(Action *)action at:(NSUInteger)index;
- (void)remove:(Action *)action;
- (BOOL)removeAt:(NSUInteger)index;
- (void)clear;
- (NSUInteger)count;
- (Action *)index:(NSUInteger)index;

- (Action *)first;
- (Action *)last;

@property (strong, nonatomic) NSString *filter;
- (NSUInteger)filteredCount;
- (Action *)filteredIndex:(NSUInteger)index;

- (instancetype)clone:(Action *)parent;

+ (instancetype)create:(NSString *)key dataSource:(id <NSPropertyDataSource>)dataSource mode:(BASKET_MODE)mode;

@end
