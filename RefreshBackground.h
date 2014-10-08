//
//  RefreshBackground.h
//  MultyChoice
//
//  Created by Yuliia on 02.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParsingDataFromYahoo.h"
#import "DataBaseManager.h"


@interface RefreshBackground : NSObject
+ (void) backgroundRefresh:(void (^)(UIBackgroundFetchResult))completionHanler;
@end
