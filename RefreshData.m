//
//  RefreshData.m
//  MultyChoice
//
//  Created by Yuliia on 10.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "RefreshData.h"

@implementation RefreshData
//manual refresh
+ (void)refreshTableViewWithCompletionHandler:(void (^)(BOOL ))completionHandler {
    DataBaseManager *dataBaseManager = [DataBaseManager sharedManager];
    RateHistory *exemplair = [dataBaseManager.fetchedRateHistory firstObject];
    [ParsingDataFromYahoo asynchronousRequestWithcompletionHandler:^(NSMutableDictionary* rateDict) {
        if (rateDict != nil){
            [RateHistory rewriteEntityObject :exemplair withAcceptedData:rateDict];
            completionHandler(YES);
        } else completionHandler(NO);
    }];
}
//performing refresh in background mode
+ (void) backgroundRefresh:(void (^)(UIBackgroundFetchResult))completionHanler {
    DataBaseManager *dataBaseManager = [DataBaseManager sharedManager];
    RateHistory *exemplair = [dataBaseManager.fetchedRateHistory firstObject];
    NSMutableDictionary *result = [ParsingDataFromYahoo synchronousRequest];
    completionHanler(UIBackgroundFetchResultNewData);
    if (result != nil) {
        [RateHistory rewriteEntityObject :exemplair withAcceptedData:result];
        NSLog(@"rewritten object --->>> from background fetch");
    }
}
@end
