//
//  CurrencyCalculation.m
//  MultyChoice
//
//  Created by Admin on 20.09.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "CurrencyCalculation.h"

@implementation CurrencyCalculation
// performing the calculation depending on the entered amount  of the main currency
- (double)convertNumber:(double)amount
             OfCurrency:(NSString *)mainCurrency
                   into:(NSString *)currency {
    double mainRate = [mainCurrency doubleValue];
    double rate = [currency doubleValue];
    double result = rate / mainRate * amount;
    return result;
}
@end
