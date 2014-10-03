//
//  UsedData.m
//  MultyChoice
//
//  Created by Yuliia on 26.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "UsedData.h"

@implementation UsedData

- (id)initData // that is the currencies information source (titles,
               // abbreviations and icons)
{
  self = [super init];
  if (self) {
    _shortNames = @[
      @"UAH",
      @"USD",
      @"EUR",
      @"GBP",
      @"PLN",
      @"CAD",
      @"AUD",
      @"JPY",
      @"CNY",
      @"XAU"
    ];
    _flags = @[
      @"UAH.png",
      @"USD.png",
      @"EUR.png",
      @"GBP.png",
      @"PLN.png",
      @"CAD.png",
      @"AUD.png",
      @"JPY.png",
      @"CNY.png",
      @"XAU.jpg"
    ];
    _fullNames = @[
      @"Ukrainian Hryvnia",
      @"United States Dollar",
      @"European Euro",
      @"United Kingdom Pound",
      @"Polish Zloty",
      @"Canadian Dollar",
      @"Australian Dollar",
      @"Japan Yena",
      @"Chinese Youan",
      @"Gold Ounce"
    ];
  }
  return self;
}

@end
