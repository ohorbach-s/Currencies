//
//  DataBaseManager.m
//  MultyChoice
//
//  Created by Yuliia on 02.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "DataBaseManager.h"
#import "AppDelegate.h"
#import "RateHistory.h"

@implementation DataBaseManager

+ (id)sharedManager {
    static DataBaseManager *sharedDataBaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataBaseManager = [[DataBaseManager alloc] init];
    });
    [sharedDataBaseManager extractDataBase];
    return sharedDataBaseManager;
}
- (id)init {
    if (self = [super init]) {
        _fetchedArrayOfCurrencyInfo = [[NSMutableArray alloc] init];
        _fetchedRateHistory = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)extractDataBase {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *req = [NSFetchRequest new];
    NSString *currencyInfoEntityName = @"CurrencyInfo";
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:currencyInfoEntityName
                inManagedObjectContext:context];
    
    [req setEntity:entityDesc];
    NSArray *tempArrayForCurrencyInfo =
    [context executeFetchRequest:req error:&error];
    _fetchedArrayOfCurrencyInfo =
    [NSMutableArray arrayWithArray:tempArrayForCurrencyInfo];
    NSFetchRequest *mainReq = [NSFetchRequest new];
    NSString *rateHistoryEntityName = @"RateHistory";
    NSEntityDescription *mainRate =
    [NSEntityDescription entityForName:rateHistoryEntityName
                inManagedObjectContext:context];
    [mainReq setEntity:mainRate];
    NSArray *fetchArrayForRateHistory =
    [context executeFetchRequest:mainReq error:&error];
    _fetchedRateHistory =
    [NSMutableArray arrayWithArray:fetchArrayForRateHistory];
}
// fill the DB when the app is launched for the first time
+ (void)startWorkWithCurrencyRateAplication {
    [CurrencyInfo firstCurrencyInfoInitialization];                         // creating currency information entity
    [ParsingDataFromYahoo
     asynchronousRequestWithcompletionHandler: ^(NSMutableDictionary *rateDict) {           // implementing the asynchronous
         if (rateDict != nil) {
             [RateHistory
              newEntityObject:rateDict];         // filling the rate entity
         } else {                                     // in case there is no internet connection available =D
             UIAlertView *message = [[UIAlertView alloc]
                                     initWithTitle:@"No Internet connection"
                                     message:@"The app is launched for the first time "
                                     @"and Data source is empty"
                                     delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                     otherButtonTitles:nil];
             [message show];                         // displaynig the relevant alert
         }
     }];
}
@end
