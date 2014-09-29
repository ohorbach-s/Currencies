//
//  CurrencyCalculation.m
//  MultyChoice
//
//  Created by Admin on 20.09.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "CurrencyCalculation.h"

@implementation CurrencyCalculation


-(double) convertNumber: (NSString *)amount OfCurrency: (NSString *)mainCurrency into: (NSString *)currency    // performing the calculation depending on the entered amount of the main currency
{
    
    double number = [amount doubleValue];
    double mainRate = [mainCurrency doubleValue];
    double rate = [currency doubleValue];
    double result = rate/mainRate * number;
    
    return result;
}


@end
