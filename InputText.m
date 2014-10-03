//
//  InputText.m
//  MultyChoice
//
//  Created by Yuliia on 03.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "InputText.h"


@implementation InputText

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       _dots = 0;
    }
    return self;
}

- (void)checkTyping {
   
    if ([self.text rangeOfString:@"."].location != NSNotFound) {
        _dots ++;
    } else {
        _dots=0;
    }
    
    if ([self.text hasSuffix: @"."] && _dots >=2) {
        self.text = [self.text substringToIndex: self.text.length - 1];
    }
   
    
    if ([self.text hasPrefix:@"."]) {
        self.text = @"0.";
        _dots++;
    }
    
    if ([self.text hasPrefix:@"0"] && self.text.length == 2 && ![self.text hasPrefix:@"0."]) {
       NSRange range = NSMakeRange(1, [ self.text length] - 1);
        self.text = [self.text substringWithRange:range];
    }
    
    if (self.text.length > 9) {
        self.text = [self.text substringToIndex: [self.text length] - 1];
    }
}

@end
