//
//  ModelBasket.h
//  Done!
//
//  Created by Alexander Ivanov on 15.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Basket.h"
#import "Settings.h"
#import "CloudStatistics.h"
#import "TourBasket.h"

@interface ModelBasket : TourBasket

@property (strong, nonatomic) Basket *basket;
@property (strong, nonatomic) Settings *settings;
@property (strong, nonatomic) CloudStatistics *statistics;

- (NSUInteger)rowForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForRow:(NSUInteger)row;
- (BOOL)didUpdateModel;	// abstract

- (void)done:(NSIndexPath *)indexPath;
- (void)undone:(NSIndexPath *)indexPath;
- (void)deferral:(NSIndexPath *)indexPath date:(NSDate *)date;
- (void)calendar:(NSIndexPath *)indexPath date:(NSDate *)date repeat:(NSNumber *)repeat sound:(NSString *)sound alert:(NSNumber *)alert;
- (void)delegate:(NSIndexPath *)indexPath owner:(NSInteger)owner ownerDescription:(NSString *)ownerDescription;

- (void)add:(NSIndexPath *)indexPath;
- (void)remove:(NSIndexPath *)indexPath;
- (void)inBasket:(NSIndexPath *)indexPath;
- (void)clear:(NSArray *)indexPaths;

- (void)edit:(NSIndexPath *)indexPath title:(NSString *)title;
- (void)editAndSort:(NSIndexPath *)indexPath title:(NSString *)title;

- (void)order:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath;

- (void)import:(Action *)action;

@end
