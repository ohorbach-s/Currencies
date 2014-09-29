//
//  ParcingYahoo.h
//  MultyChoice
//
//  Created by Admin on 15.09.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateHistory.h"


@interface ParcingYahoo : NSObject


- (void) convertwithBlock:(void (^)(NSMutableDictionary *)) block;

@end
