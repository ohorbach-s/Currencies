//
//  WorkWithDB.h
//  MultyChoice
//
//  Created by Yuliia on 26.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateHistory.h"

@interface WorkWithDB : NSObject



-(void) DBCheckWithBlock: (void (^)(NSString *)) block;
-(RateHistory*) the_same_func;

@end
