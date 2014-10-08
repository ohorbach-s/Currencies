//
//  InputText.m
//  MultyChoice
//
//  Created by Yuliia on 03.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "InputText.h"



@interface InputText ()
@end
@implementation InputText

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dots = 0;
    }
    return self;
}

- (void)checkTyping {
    if ([self.text rangeOfString:@"."].location != NSNotFound) {
        _dots++;
    } else {
        _dots = 0;
    }
    if ([self.text hasSuffix:@"."] && _dots >= 2) {
        self.text = [self.text substringToIndex:self.text.length - 1];
    }
    if ([self.text hasPrefix:@"."]) {
        self.text = @"0.";
        _dots++;
    }
    if ([self.text hasPrefix:@"0"] && self.text.length == 2 && ![self.text hasPrefix:@"0."]) {
        NSRange range = NSMakeRange(1, [self.text length] - 1);
        self.text = [self.text substringWithRange:range];
    }
    if (self.text.length > 9) {
        self.text = [self.text substringToIndex:[self.text length] - 1];
    }
}

-(void)customButton {
    UIToolbar* numberToolbar =
    [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray
                           arrayWithObjects:
                           [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                            style:UIBarButtonItemStyleBordered
                                                           target:self
                                                           action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                            target:nil
                            action:nil],
                           [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OK", nil)
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.inputAccessoryView = numberToolbar;
    
}
- (void)cancelNumberPad {
    self.text = @"1";
    self.dots = 0;
    [self resignFirstResponder];
    [self.reloadDelegate reloadTable];
}

- (void)doneWithNumberPad {
    if ([self.text hasSuffix:@"."]) {
        self.text = [self.text substringToIndex:[self.text length] - 1];
    }
    if([self.text isEqualToString:@""]) {
        self.text = @"1";
    }
    self.dots = 0;
    [self resignFirstResponder];
    [self.reloadDelegate reloadTable];
}




@end
