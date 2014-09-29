//
//  CurrencyCalculation.h
//  MultyChoice
//
//  Created by Admin on 20.09.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyCalculation : NSObject


-(double) convertNumber: (NSString *)amount OfCurrency: (NSString *)mainCurrency into: (NSString *)currency;


@end
