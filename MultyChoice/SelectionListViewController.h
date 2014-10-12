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
#import "RateHistory.h"
#import "DataBaseManager.h"
#import "AnimationFile.h"
#import <QuartzCore/QuartzCore.h>

@protocol AddCurrencyDelegate <NSObject>
- (void)receiveMainCurrencyFromSelectionTable:(CurrencyInfo*)SelectedMain;
@end

@interface SelectionListViewController
    : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) BOOL selectedMainSegue;
@property(nonatomic, weak) id<AddCurrencyDelegate> delegate;
@property(strong, nonatomic) NSString *selectedCurrency;
@property (assign, nonatomic) CATransform3D initialTransformation;
@property (nonatomic, strong) NSMutableSet *shownIndexes;


@end
