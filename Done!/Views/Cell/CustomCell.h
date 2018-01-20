//
//  CustomCell.h
//  Done!
//
//  Created by Alexander Ivanov on 19.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@end
