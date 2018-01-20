//
//  Basket.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Basket.h"
#import "NSArray+Query.h"
#import "NSHelper.h"
#import "Workflow.h"

@interface Basket ()
@property (strong, nonatomic) NSDate *changed;

@property (strong, nonatomic) NSMutableArray *obsolete;

@property (strong, nonatomic) NSMutableArray *filtered;
@end

@implementation Basket

- (NSMutableArray *)obsolete {
	if (!_obsolete)
		_obsolete = [[NSMutableArray alloc] init];
	
	return _obsolete;
}

- (NSPropertyDictionary *)createItem {
	__strong Action *item = [[Action alloc] init];
	item.parent = self;
	return item;
}

- (NSPropertyDictionary *)loadItem:(id)object {
	if (self.mode == SINGLE_FILE)
		return [super loadItem:object];
	
	Action *item = (Action *)[super loadItem:object];
	
	if ([object isKindOfClass:[NSString class]]) {
		item.uuid = (NSString *)object;
		
		if (self.mode != DISTRIBUTED_LAZY)
			[item load];
	}
	
	return item;
}

- (id)saveItem:(NSPropertyDictionary *)item {
	if (self.mode == SINGLE_FILE)
		return [super saveItem:item];
	
	[item save];
	
	return item.key;
}

- (BOOL)isChanged {
	return self.changed || self.mode != DISTRIBUTED_LAZY;
}

- (id <NSPropertyDataSource>)dataSource {
	return self.parent ? self.parent.dataSource : [super dataSource];
}

- (BASKET_MODE)mode {
	return self.parent.parent ? self.parent.parent.mode : _mode;
}

- (instancetype)initWithParent:(Action *)parent {
	self = [self init];
	
	if (self)
		self.parent = parent;
	
	return self;
}

- (void)add:(Action *)action {
	if (!action)
		return;
	
    [self.array addObject:action];
	
	[self.obsolete removeObject:action];
	action.parent = self;
	
	self.changed = [NSDate date];
	
	self.filter = self.filter;
}

- (void)addRange:(NSArray *)array {
    [self.array addObjectsFromArray:array];
	
	for (Action *action in array) {
		[self.obsolete removeObject:action];
		action.parent = self;
	}
	
	self.changed = [NSDate date];
	
	self.filter = self.filter;
}

- (BOOL)add:(Action *)action at:(NSUInteger)index {
	index = [self toFilteredIndex:index];
	
	if (index > [self count] || index == NSNotFound)
		return NO;
	
	[self.array insertObject:action atIndex:index];
	
	[self.obsolete removeObject:action];
	action.parent = self;
	
	self.changed = [NSDate date];
	
	self.filter = self.filter;
	
	return YES;
}

- (void)remove:(Action *)action {
    [self.array removeObject:action];
	
	[self.obsolete addObject:action];
	action.parent = Nil;
	
	self.changed = [NSDate date];
	
	self.filter = self.filter;
}

- (BOOL)removeAt:(NSUInteger)index {
	index = [self toFilteredIndex:index];
	
	if (index >= [self count] || index == NSNotFound)
		return NO;
	
	Action *action = self.array[index];
	
	[self.array removeObjectAtIndex:index];
	
	[self.obsolete addObject:action];
	action.parent = Nil;
	
	self.changed = [NSDate date];
	
	self.filter = self.filter;
	
	return YES;
}

- (void)clear {
	NSUInteger count = [self count];
	for (NSUInteger index = 0; index < count; index++)
		[self removeAt:index];
}

- (NSUInteger)count {
    return [self.array count];
}

- (Action *)first {
	return [self index:0];
}

- (Action *)last {
	return [self index:[self count] - 1];
}

- (Action *)index:(NSUInteger)index {
    Action *action = index < [self count] ? self.array[index] : Nil;
	
	if (!action.created)
		[action load];
	
	return action;
}

- (void)load {
	[super load];
	
	self.changed = Nil;
}

- (void)save {
	[self clearObsolete];
	
	if (self.parent.parent) {
		self.parent.changed = [NSDate date];
		
		[self.parent.parent save];
	} else {
		[super save];
		
		self.changed = Nil;
	}
}

- (void)clearObsolete {
	if (!_obsolete)
		return;
	
	NSArray *obsolete = _obsolete;
	_obsolete = Nil;
	for (Action *action in obsolete)
		[self removeAction:action];
}

- (void)removeAction:(Action *)action {
	[self.dataSource removeByKey:action.key];
	
	if (!action.folder)
		return;
	
	NSUInteger count = [action.folderValues count];
	for (NSUInteger index = 0; index < count; index++)
		[self removeAction:[action.folderValues index:index]];
}

- (void)setFilter:(NSString *)filter {
	if (filter) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		
		NSUInteger count = [self count];
		for (NSUInteger index = 0; index < count; index++) {
			Action *action = [self index:index];
			
			if ([action.title rangeOfString:filter options:NSCaseInsensitiveSearch].location != NSNotFound)
				[array addObject:@(index)];
		}
		
		self.filtered = array;
	} else {
		self.filtered = Nil;
	}
	
	_filter = filter;
}

- (NSUInteger)filteredCount {
    return self.filtered ? [self.filtered count] : [self.array count];
}

- (NSUInteger)toFilteredIndex:(NSUInteger)index {
	return self.filtered ? [self.filtered[index] unsignedIntegerValue] : index;
}

- (Action *)filteredIndex:(NSUInteger)index {
	return index < [self filteredCount] ? [self index:[self toFilteredIndex:index]] : Nil;
}

- (instancetype)clone:(Action *)parent {
	Basket *instance = [[[self class] alloc] initWithParent:parent];
	
	NSUInteger count = [self filteredCount];
	for (NSUInteger index = 0; index < count; index++)
		[instance add:[[self filteredIndex:index] clone:YES]];
	
	return instance;
}

+ (instancetype)create:(NSString *)key dataSource:(id <NSPropertyDataSource>)dataSource mode:(BASKET_MODE)mode {
	Basket *basket = [[Basket alloc] initWithKey:key];
	basket.dataSource = dataSource;
	basket.mode = mode;
	[basket load];
	
	return basket;
}

@end
