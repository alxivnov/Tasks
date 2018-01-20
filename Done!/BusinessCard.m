//
//  BusinessCard.m
//  Done!
//
//  Created by Alexander Ivanov on 06.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "BusinessCard.h"

@interface BusinessCard ()
@property (strong, nonatomic) NSObject *name;
@end

@implementation BusinessCard

@synthesize name = Alex_Ivanov;

+ (NSString *)contacts {
	// alex.p.ivanov@gmail.com
	return @"+7(707)850-05-65";
}

@end
