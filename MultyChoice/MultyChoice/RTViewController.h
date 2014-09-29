//
//  RTViewController.h
//  MultyChoice
//
//  Created by Andriy on 9/5/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectionListViewController.h"
#import "Starter.h"
#import "RTTableViewCell.h"
#import "ParcingYahoo.h"
#import "RTAppDelegate.h"
#import "CurrencyCalculation.h"
#import "WorkWithDB.h"
#import "ParsingSynchronous.h"



@interface RTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddCurrencyDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *mainFullName;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) ParcingYahoo *converter;
@property (weak, nonatomic) IBOutlet UITextField *howMuch;


- (IBAction)endEditing:(id)sender;
-(IBAction)refreshTableView:(id)sender;
- (void) backgroundRefresh:(void (^)(UIBackgroundFetchResult))completionHanler;

@end