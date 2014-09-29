//
//  RateHistory.m
//  MultyChoice
//
//  Created by Yuliia on 21.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "RateHistory.h"
#import "CurrencyInfo.h"
#import "RTAppDelegate.h"


@implementation RateHistory

@dynamic date;
@dynamic usd;
@dynamic uah;
@dynamic gbp;
@dynamic aud;
@dynamic cad;
@dynamic pln;
@dynamic xau;
@dynamic cny;
@dynamic jpy;
@dynamic eur;




+(void) rewriteEntityObject :(NSMutableDictionary*)dict :(RateHistory*)objectToRewrite                                                  // rewrite the last retrieved Entity object
{
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    UsedData *getData = [[UsedData alloc] initData];
    for (int j = 0; j < [getData.shortNames count]; j++){
        
        [objectToRewrite setValue:[dict valueForKey:[getData.shortNames objectAtIndex:j]]forKey:[[getData.shortNames objectAtIndex:j]lowercaseString]];
        
    }
    NSDate *now = [NSDate date];
    objectToRewrite.date = now;
    NSError *error;
    [context save:&error];
                                                 NSLog(@"rewriten rate history object::: uah %@ , date ::: %@", [objectToRewrite valueForKey:@"uah"], [objectToRewrite valueForKey:@"date"]);
}
+(void) newEntityObject :(NSMutableDictionary*)dict                                                                                        //add new Entity object
{
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    UsedData *getData = [[UsedData alloc] initData];
    RateHistory *newResult = [NSEntityDescription insertNewObjectForEntityForName:@"RateHistory" inManagedObjectContext:context];
    for (int j = 0; j < [getData.shortNames count]; j++){
        
        [newResult setValue:[dict valueForKey:[getData.shortNames objectAtIndex:j]]forKey:[[getData.shortNames objectAtIndex:j]lowercaseString]];
}
    
    NSDate *now = [NSDate date];
    newResult.date = now;
    NSError *error;
    [context save:&error];
                                                  NSLog(@"new added object:: uah %@  date::: %@", [newResult valueForKey:@"uah"], [newResult valueForKey:@"date"]);
}

@end
