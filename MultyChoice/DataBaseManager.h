//
//  DataBaseManager.h
//  MultyChoice
//
//  Created by Yuliia on 02.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyInfo.h"
//#import "RateHistory.h"

@class RateHistory;

@interface DataBaseManager : NSObject

@property (nonatomic, strong) NSMutableArray *fetchedArrayOfCurrencyInfo;
@property (nonatomic, strong) NSMutableArray *fetchedRateHistory;

+(id)sharedManager;
+(void) startWorkWithCurrencyRateAplication;
@end
