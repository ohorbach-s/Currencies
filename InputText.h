//
//  InputText.h
//  MultyChoice
//
//  Created by Yuliia on 03.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReloadTableViewDelegate <NSObject, UITextFieldDelegate>

- (void)reloadTable;

@end

@interface InputText : UITextField

@property (nonatomic,weak)id<ReloadTableViewDelegate>reloadDelegate;

@property (nonatomic, assign)int dots;

- (void)checkTyping;
-(void)customButton;
-(void)reloadFromInput;

@end
