//
//  RateView.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 06.12.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateView : UIView

@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic, readonly) UILabel *textLabel;

@property (strong, nonatomic) IBInspectable UIImage *image;
@property (strong, nonatomic) IBInspectable NSString *text;

- (void)open:(NSString *)string withDuration:(NSTimeInterval)duration;

@end
