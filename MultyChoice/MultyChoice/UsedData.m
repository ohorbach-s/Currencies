//
//  UsedData.m
//  MultyChoice
//
//  Created by Yuliia on 26.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "UsedData.h"

@implementation UsedData


-(id) initData                                                                                     //that is the currencies information source (titles, abbreviations and icons)
{
    self =[super init];
    if(self){
    _shortNames = @[@"UAH", @"USD", @"EUR", @"GBP", @"PLN", @"CAD", @"AUD", @"JPY", @"CNY", @"XAU"];
    _flags = @[@"UAH.png", @"USD.png", @"EUR.png", @"GBP.png", @"PLN.png", @"CAD.png", @"AUD.png",@"JPY.png", @"CNY.png", @"XAU.jpg"];
    _fullNames = @[@"ukrainian hryvnia", @"united states dollar", @"united europe euro", @"united kingdom pound", @"polish zloty", @"canadian dollar", @"australian dollar", @"japan yena", @"china youan", @"gold"];
    }
        return self;
    
}

@end
