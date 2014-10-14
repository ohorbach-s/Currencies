//
//  CurrencyInfo.m
//  MultyChoice
//
//  Created by Yuliia on 21.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "CurrencyInfo.h"
@implementation CurrencyInfo

@dynamic abbrev;
@dynamic fullName;
@dynamic icon;
@dynamic checked;
@dynamic rate;


+ (void)firstCurrencyInfoInitialization {
    UsedData *getData = [[UsedData alloc] initData];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    for (int j = 0; j < [getData.shortNames count]; j++) {
        CurrencyInfo *newResult = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"CurrencyInfo"
                                   inManagedObjectContext:context];
        newResult.abbrev = [getData.shortNames objectAtIndex:j];
        newResult.fullName = [getData.fullNames objectAtIndex:j];
        newResult.icon = [getData.flags objectAtIndex:j];
        newResult.checked = nil;
        NSError *error;
        [context save:&error];
    }
}

@end
