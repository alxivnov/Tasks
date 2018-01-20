//
//  EditableCell.h
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "GestureCell.h"

@class EditableCell;

@protocol EditableCellDelegate <NSObject>

@optional

- (void)didBeginEditing:(EditableCell *)sender;

- (void)willEndEditing:(EditableCell *)sender;
- (void)didEndEditing:(EditableCell *)sender;

@end

@interface EditableCell : GestureCell <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic, readonly) NSString *editedText;

- (void)beginEditing:(NSString *)placeholder;
- (void)endEditing:(NSString *)placeholder;
- (void)endEditing;
- (BOOL)isEditing;

@property (nonatomic, assign) id <EditableCellDelegate> delegate;

@end
