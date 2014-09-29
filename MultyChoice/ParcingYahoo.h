//
//  ParcingYahoo.h
//  MultyChoice
//
//  Created by Admin on 15.09.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateHistory.h"
//#import "RTViewController.h"


@interface ParcingYahoo : NSObject//<Parcing>

@property (nonatomic, strong)NSArray *shortNames;
@property (nonatomic, strong) RateHistory *freshResult;

- (void) convertUsdInto: (NSString*) currency withBlock:(void (^)(NSString *))block;
-(void)refreshData;

@end
