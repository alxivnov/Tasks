//
//  BasicCell.h
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "OrderableCell.h"
#import "PannableUnit.h"

@class PannableCell;

@protocol PannableCellDelegate <NSObject>

@optional

- (void)didPan:(PannableCell *)sender fromUnit:(PannableUnit *)unit;
- (void)didPan:(PannableCell *)sender toOffset:(CGFloat)offset;

- (void)willEndPanning:(PannableCell *)sender;
- (void)didEndPanning:(PannableCell *)sender;

- (void)didCancelPanning:(PannableCell *)sender;

- (void)didTap:(PannableCell *)sender;

@end

@interface PannableCell : OrderableCell

@property (strong, nonatomic) NSArray *leftUnits;
@property (strong, nonatomic) NSArray *rightUnits;

@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIColor *fullColor;
@property (strong, nonatomic) PannableUnit *unit;

@property (strong, nonatomic) PannableUnit *selectedUnit;
@property (nonatomic, assign) BOOL isPanning;

@property (nonatomic, assign) id <PannableCellDelegate, OrderableCellDelegate, EditableCellDelegate> delegate;

- (void)cancel;
- (void)done;

- (UIView *)anchor;

- (void)setArrowByTranslation:(CGFloat)translation;

- (void)setOrigins;
- (void)setTitleOffset:(CGFloat)offset;
- (void)setImageOffset:(CGFloat)offset restricted:(BOOL)flag;

- (void)disposeImage;

+ (CGFloat)margin;
+ (CGFloat)marginCorrection;

@end
