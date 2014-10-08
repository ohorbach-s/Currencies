//
//  RateHistory.h
//  MultyChoice
//
//  Created by Yuliia on 21.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UsedData.h"
#import "ParsingDataFromYahoo.h"


@interface RateHistory : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * usd;
@property (nonatomic, retain) NSString * uah;
@property (nonatomic, retain) NSString * gbp;
@property (nonatomic, retain) NSString * aud;
@property (nonatomic, retain) NSString * cad;
@property (nonatomic, retain) NSString * pln;
@property (nonatomic, retain) NSString * xau;
@property (nonatomic, retain) NSString * cny;
@property (nonatomic, retain) NSString * jpy;
@property (nonatomic, retain) NSString * eur;

@end

@interface RateHistory (CoreDataGeneratedAccessors)


+(void) rewriteEntityObject :(RateHistory*)objectToRewrite withAcceptedData:(NSMutableDictionary*)dict;
+(void) newEntityObject :(NSMutableDictionary*)dict;


@end
