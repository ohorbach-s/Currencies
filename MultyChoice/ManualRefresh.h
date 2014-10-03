//
//  ManualRefresh.h
//  MultyChoice
//
//  Created by Yuliia on 02.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseManager.h"
#import "RateHistory.h"

@interface ManualRefresh : NSObject
+ (void)refreshTableViewWithCompletionHandler:(void (^)(NSString* ))completionHandler;
@end
