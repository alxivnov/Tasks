//
//  AlertBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 15.12.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "ModelBasket.h"

@interface AlertBasket : ModelBasket

- (void)done:(NSIndexPath *)indexPath;
- (void)undone:(NSIndexPath *)indexPath;
- (void)deferral:(NSIndexPath *)indexPath date:(NSDate *)date;
- (void)calendar:(NSIndexPath *)indexPath date:(NSDate *)date repeat:(NSNumber *)repeat sound:(NSString *)sound alert:(NSNumber *)alert;
- (void)delegate:(NSIndexPath *)indexPath owner:(NSInteger)owner ownerDescription:(NSString *)ownerDescription;

- (void)add:(NSIndexPath *)indexPath;
- (void)remove:(NSIndexPath *)indexPath;
- (void)clear:(NSArray *)indexPaths;

- (void)edit:(NSIndexPath *)indexPath title:(NSString *)title;
//- (void)editAndSort:(NSIndexPath *)indexPath title:(NSString *)title;

//- (void)order:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath;

- (void)import:(Action *)action;

- (void)significantTimeChange;

@end
