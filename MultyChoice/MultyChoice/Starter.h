//
//  Starter.h
//  MultyChoice
//
//  Created by Yuliia on 19.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParcingYahoo.h"
#import "RTAppDelegate.h"
#import "CurrencyInfo.h"
#import "RateHistory.h"
#import "UsedData.h"



@interface Starter : NSObject

@property(nonatomic, strong) NSArray *shortNames;
@property(nonatomic, strong) NSArray *fullNames;
@property(nonatomic, strong) NSArray *flags;


-(void) firstLoad;

@end
