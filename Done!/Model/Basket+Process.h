//
//  Basket+Process.h
//  Done!
//
//  Created by Alexander Ivanov on 07.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Basket.h"

@interface Basket (Process)

- (BOOL)moveRowAt:(NSUInteger)index to:(NSUInteger)newIndex;
- (NSUInteger)sortRowAt:(NSUInteger)index;

- (NSUInteger)merge:(Action *)action at:(NSUInteger)index;

@end
