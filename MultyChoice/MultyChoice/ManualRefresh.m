//
//  ManualRefresh.m
//  MultyChoice
//
//  Created by Yuliia on 02.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "ManualRefresh.h"

@implementation ManualRefresh


+ (void)refreshTableViewWithCompletionHandler:(void (^)(BOOL ))completionHandler                                                                          //downloading fresh data on exchange rate from yahoo and loading it to DB MANUALLY
{
    DataBaseManager *dataBaseManager = [DataBaseManager sharedManager];
    RateHistory *exemplair = [dataBaseManager.fetchedRateHistory firstObject];
    
    [ParsingDataFromYahoo asynchronousRequestWithcompletionHandler:^(NSMutableDictionary* rateDict)
     {
         if (rateDict != nil){
             [RateHistory rewriteEntityObject :exemplair withAcceptedData:rateDict];
             }                                                //    otherwise, creting new Entity object
     NSLog(@"writing to DB ended");
     completionHandler(YES);
     }];
    
}
@end
