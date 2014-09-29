//
//  SelectionListViewController.h
//  MultyChoice
//
//  Created by AdminAccount on 9/7/14.
//  Copyright (c) 2014 AdminAccount. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTTableViewCell.h"
#import "RTAppDelegate.h"
#import "Starter.h"
#import "UsedData.h"


@protocol AddCurrencyDelegate <NSObject>


- (void) setSelectedCurrency: (unsigned int) amount;
- (void) setMainCurrency: (unsigned int) indexTableRow;

@end


@interface SelectionListViewController: UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic) BOOL selectedMainSegue;
@property (nonatomic)unsigned int amount;
@property (nonatomic, weak) id <AddCurrencyDelegate>delegate;
@property (strong, nonatomic) NSString *selectedCurrency;


- (IBAction)done:(UIBarButtonItem *)sender;

@end
