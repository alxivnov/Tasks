//
//  Action+Task.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 04.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Folder.h"
#import "Action+Repeat.h"
#import "Action+Task.h"

@implementation Action (Task)

- (Task *)toTask {
	Task *task = [[Task alloc] init];
	
	task.title = [self folderDescription];
	task.titleLength = self.folder ? [self.title length] : 0;
	task.state = self.state;
	task.date = self.date;
	task.dateDescription = [self repeatDateDescription];
	task.uuid = self.uuid;
	
	return task;
}

@end
