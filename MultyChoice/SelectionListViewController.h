//
//  SelectionListViewController.h
//  MultyChoice
//
//  Created by AdminAccount on 9/7/14.
//  Copyright (c) 2014 AdminAccount. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "AppDelegate.h"
#import "UsedData.h"
#import "CurrencyInfo.h"
#import "DataBaseManager.h"

@protocol AddCurrencyDelegate <NSObject>
- (void)setMainCurrency:(unsigned int)indexTableRow;
@end

@interface SelectionListViewController
    : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) BOOL selectedMainSegue;
@property(nonatomic) unsigned int amount;
@property(nonatomic, weak) id<AddCurrencyDelegate> delegate;
@property(strong, nonatomic) NSString *selectedCurrency;

- (IBAction)done:(UIBarButtonItem *)sender;

@end
