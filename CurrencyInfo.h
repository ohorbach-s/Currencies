//
//  CurrencyInfo.h
//  MultyChoice
//
//  Created by Yuliia on 21.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RateHistory;

@interface CurrencyInfo : NSManagedObject

@property (nonatomic, retain) NSString * abbrev;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * checked;
@property (nonatomic, retain) RateHistory *toHistory;

@end
