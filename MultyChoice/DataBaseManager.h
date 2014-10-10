//
//  DataBaseManager.h
//  MultyChoice
//
//  Created by Yuliia on 02.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyInfo.h"

@interface DataBaseManager : NSObject
@property (nonatomic, strong) NSMutableArray *fetchedArrayOfCurrencyInfo;
@property (nonatomic, strong) NSMutableArray *fetchedRateHistory;

+(id)sharedManager;
+(void) startWorkWithCurrencyRateAplication;
//-(void)rememberAboutMainCurrency: (NSString *) mainCurrencyName withKey: (NSString *) key;
//+(BOOL)checkApplicationLaunch: (NSString *) key;
//+(void)rememberAboutApplicationLaunchWithKey:(NSString *) key;
//-(NSString *) recallAboutMainCurrencyUsingKey: (NSString*) key;
@end
