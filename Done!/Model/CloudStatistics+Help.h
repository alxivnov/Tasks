//
//  Statistics+Interface.h
//  Done!
//
//  Created by Alexander Ivanov on 31.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "CloudStatistics.h"

@interface CloudStatistics (Help)

- (BOOL)hintTop;
- (BOOL)hintLeft;
- (BOOL)hintRight;
- (BOOL)hintBottom:(BOOL)folder;

- (BOOL)tourTop;
- (BOOL)tourLeft;
- (BOOL)tourRight;
- (BOOL)tourBottom;

- (BOOL)tour;

@end
