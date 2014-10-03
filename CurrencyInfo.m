//
//  CurrencyInfo.m
//  MultyChoice
//
//  Created by Yuliia on 21.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "CurrencyInfo.h"
#import "RateHistory.h"

@implementation CurrencyInfo

@dynamic abbrev;
@dynamic fullName;
@dynamic icon;
@dynamic checked;

+ (void)createMe {
  UsedData *getData = [[UsedData alloc] initData];
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  NSManagedObjectContext *context = [appDelegate managedObjectContext];
  for (int j = 0; j < [getData.shortNames count]; j++) {
    CurrencyInfo *newResult = [NSEntityDescription
        insertNewObjectForEntityForName:@"CurrencyInfo"
                 inManagedObjectContext:context]; // fill the "Currency info"
                                                  // entity with the constant
                                                  // data about currencies -
                                                  // titles, abbreviations,
                                                  // icons
    newResult.abbrev = [getData.shortNames objectAtIndex:j];
    newResult.fullName = [getData.fullNames objectAtIndex:j];
    newResult.icon = [getData.flags objectAtIndex:j];
    newResult.checked = 0;

    NSError *error;
    [context save:&error];
  //  NSLog(@"currency info really created %@", newResult.abbrev);
  }
}
@end
