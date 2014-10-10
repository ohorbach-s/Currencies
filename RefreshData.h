//
//  RefreshData.h
//  MultyChoice
//
//  Created by Yuliia on 10.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseManager.h"
#import "RateHistory.h"
#import "ParsingDataFromYahoo.h"

@interface RefreshData : NSObject

+ (void)refreshTableViewWithCompletionHandler:(void (^)(BOOL ))completionHandler;
+ (void) backgroundRefresh:(void (^)(UIBackgroundFetchResult))completionHanler;

@end
