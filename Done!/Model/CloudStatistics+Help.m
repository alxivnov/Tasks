//
//  Statistics+Interface.m
//  Done!
//
//  Created by Alexander Ivanov on 31.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "CloudStatistics+Help.h"

@implementation CloudStatistics (Help)

- (BOOL)hintTop {
	return !self.beginAdd || !self.repeatingAdd;
}

- (BOOL)hintLeft {
	return ![self calculateDone] || !self.beginDeferral || !self.beginCalendar || !self.beginDelegate;
}

- (BOOL)hintRight {
	return !self.beginPanRemove || !self.beginRepeat || !self.beginFolder || !self.beginSend;
}

- (BOOL)hintBottom:(BOOL)folder {
	return !self.clear || !self.share || (folder && !self.dismissFolder) || (!folder && !self.beginLogger);
}

- (BOOL)tourTop {
	return self.beginAdd == 0 && self.repeatingAdd == 0;
}

- (BOOL)tourLeft {
	return [self calculateDone] == 0 && self.beginDeferral == 0 && self.beginCalendar == 0 && self.beginDelegate == 0;
}

- (BOOL)tourRight {
	return self.beginPanRemove == 0 && self.beginRepeat == 0 && self.beginFolder == 0 && self.beginSend == 0;
}

- (BOOL)tourBottom {
	return [self calculateDone] > 0 && self.clear == 0;
}

- (BOOL)tour {
	return [self tourTop] || [self tourLeft] || [self tourRight] || [self tourBottom];
}

@end
