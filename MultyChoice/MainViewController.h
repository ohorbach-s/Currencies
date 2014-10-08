//
//  RTViewController.h
//  MultyChoice
//
//  Created by Andriy on 9/5/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectionListViewController.h"
#import "TableViewCell.h"
#import "ParsingDataFromYahoo.h"
#import "AppDelegate.h"
#import "CurrencyCalculation.h"
#import "DataBaseManager.h"
#import "ManualRefresh.h"
#import "InputText.h"
#import "AnimationFile.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AddCurrencyDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *mainFullName;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet InputText *currencyAmount;
@property (nonatomic,strong)CurrencyInfo *mainSaved;
@property (nonatomic, strong)CurrencyInfo *mainSaved2;
@property (assign, nonatomic) CATransform3D initialTransformation;
@property (nonatomic, strong) NSMutableSet *shownIndexes;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)refreshTheMainTableView;

@end