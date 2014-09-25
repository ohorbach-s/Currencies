//
//  Starter.m
//  MultyChoice
//
//  Created by Yuliia on 19.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "Starter.h"

@implementation Starter

-(id)initStarter
{
    self = [super init];
    
    if(self){
        
        _shortNames = @[@"UAH", @"USD", @"EUR", @"GBP", @"PLN", @"CAD", @"AUD", @"JPY", @"CNY", @"XAU"];
        _flags = @[@"UAH.png", @"USD.png", @"EUR.png", @"GBP.png", @"PLN.png", @"CAD.png", @"AUD.png",@"JPY.png", @"CNY.png", @"XAU.jpg"];
        _fullNames = @[@"ukrainian hryvnia", @"united states dollar", @"united europe euro", @"united kingdom pound", @"polish zloty", @"canadian dollar", @"australian dollar", @"japan yena", @"china youan", @"gold"];
            }
    return self;
}

-(void)firstLoad{                          // fill the DB
    
    ParcingYahoo *converter = [ParcingYahoo new];
    RTAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    RateHistory *newRate = [NSEntityDescription
                            insertNewObjectForEntityForName:@"RateHistory"
                                     inManagedObjectContext:context];             //create "Rate History" entity which will comprise future yahoo exchange rate data
    NSDate *now = [NSDate date];
    newRate.date = now;
    
    for (int j = 0; j < [self.shortNames count]; j++) {

        NSLog(@"The last date is %@", now);
        CurrencyInfo *newResult = [NSEntityDescription
                               insertNewObjectForEntityForName:@"CurrencyInfo"
                                        inManagedObjectContext:context];         //fill the "Currency info" entity with the constant data about currencies - titles, abbreviations, icons
        newResult.abbrev = [self.shortNames objectAtIndex:j];
        newResult.fullName = [self.fullNames objectAtIndex:j];
        newResult.icon = [self.flags objectAtIndex:j];
        newResult.checked = NO;
        
        NSError *error;
        [context save:&error];
    
        [converter convertUsdInto: [self.shortNames objectAtIndex:j] withBlock:^(NSString *rate)  {   //reproduce the convertion of all currencies to USD

            [newRate setValue:rate forKey:[[self.shortNames objectAtIndex:j] lowercaseString]];             // fill the entity object with JSON results
            NSError *error;
            [context save:&error];
            }];
        }
}

@end
