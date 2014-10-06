//
//  RefreshBackground.m
//  MultyChoice
//
//  Created by Yuliia on 02.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "RefreshBackground.h"

@implementation RefreshBackground


+ (void) backgroundRefresh:(void (^)(UIBackgroundFetchResult))completionHanler
{
    DataBaseManager *dataBaseManager = [DataBaseManager sharedManager];
    RateHistory *exemplair = [dataBaseManager.fetchedRateHistory firstObject];
    NSMutableDictionary *result = [ParsingDataFromYahoo synchronousRequest];                                                                 //retrieving the                   data by synchronous request
    completionHanler(UIBackgroundFetchResultNewData);
                                                       //implementing the objects amount violation control
    if (result != nil)
    {
        [RateHistory rewriteEntityObject :exemplair withAcceptedData:result    ];                                                  // if there is - rewrite the last Entity object
        NSLog(@"rewritten object --->>> from background fetch");                    //        ||
    
    }
}
@end
