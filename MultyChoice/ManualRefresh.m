//
//  ManualRefresh.m
//  MultyChoice
//
//  Created by Yuliia on 02.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "ManualRefresh.h"

@implementation ManualRefresh

//yahoo and loading it to DB MANUALLY downloading fresh data on exchange rate from
+ (void)refreshTableViewWithCompletionHandler:(void (^)(BOOL ))completionHandler {
    DataBaseManager *dataBaseManager = [DataBaseManager sharedManager];
    RateHistory *exemplair = [dataBaseManager.fetchedRateHistory firstObject];
    [ParsingDataFromYahoo asynchronousRequestWithcompletionHandler:^(NSMutableDictionary* rateDict) {
        if (rateDict != nil){
            [RateHistory rewriteEntityObject :exemplair withAcceptedData:rateDict];
        }
        completionHandler(YES);
    }];
}
@end
