//
//  RepeatBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 16.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "FolderBasket.h"

@interface RepeatBasket : FolderBasket

- (void)done:(NSIndexPath *)indexPath;

- (void)skip:(NSIndexPath *)indexPath;

- (void)repeat:(NSIndexPath *)indexPath values:(NSArray *)values;

@end
