//
//  DataBaseManager.h
//  MultyChoice
//
//  Created by Yuliia on 02.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyInfo.h"
#import "AlertDisplay.h"
#import "InputText.h"

@interface DataBaseManager : NSObject
@property (nonatomic, strong) NSMutableArray *arrayOfAllCurrencyInfo;
@property (nonatomic,strong) NSMutableArray *selectedCurrencies;
@property (nonatomic, strong) NSMutableArray *fetchedRateHistory;
@property (nonatomic,weak)id<ReloadTableViewDelegate>reloadDelegate;

+(id)sharedManager;
+(void) startWorkWithCurrencyRateAplication;
- (void)extractDataBase ;

@end
