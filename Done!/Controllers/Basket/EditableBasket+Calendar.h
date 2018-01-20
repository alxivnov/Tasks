//
//  EditableBasket+Detector.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 03.04.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "EditableBasket.h"

@interface EditableBasket (Calendar)

- (void)editAndCalendar:(NSIndexPath *)indexPath title:(NSString *)title date:(NSDate *)date;

- (void)addAndCalendar:(NSIndexPath *)indexPath title:(NSString *)title date:(NSDate *)date;

@end
