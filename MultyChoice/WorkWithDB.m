//
//  WorkWithDB.m
//  MultyChoice
//
//  Created by Yuliia on 26.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "WorkWithDB.h"
#import "RTAppDelegate.h"
#import "RTViewController.h"

@implementation WorkWithDB

-(RateHistory*) the_same_func                                                                 //preparing for work with DB
{

    RTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"RateHistory"
                                    inManagedObjectContext: context]];
    NSError *error;
    NSArray *fetched = [context executeFetchRequest:request
                                              error:&error];
    RateHistory *exemplair = [fetched lastObject];                                            //retrieve the last Entity object
    NSUInteger count = [context countForFetchRequest: request
                                               error: &error];
    if (count > 7)
    {                                                                         // if there is more than 7 objects - let's delete the most out-of-date one
        [request setFetchLimit:1];
        NSArray *fetched = [context executeFetchRequest:request
                                                  error:&error];
        RateHistory *rateToDelete = fetched[0];
        [context deleteObject:rateToDelete];
        [context save:&error];
    }
    return exemplair;
}


-(void) DBCheckWithBlock:(void (^)(NSString *)) block

{
    ParcingYahoo *parser = [ParcingYahoo new];
    RateHistory *exemplair2 = [self the_same_func];           //preparing for work with DN and checking the current DB ebtities objects (amount)
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strMyDate= [dateFormatter stringFromDate:now];
    NSString *lastSaveString = [dateFormatter stringFromDate:exemplair2.date];
        
    [parser convertwithBlock:^(NSMutableDictionary* rateDict)
    {
        if (rateDict != nil){
            if([strMyDate isEqualToString:lastSaveString])                  //   check whether there is already updates for the current date
                                                                            //        ||
        {                                                                   //        \/
            [RateHistory rewriteEntityObject:rateDict :exemplair2];
                                     NSLog(@"rewrited entity object  --->>> from workingWith DB");                                //    if it is - rewriting that EntityObject
        }else   {  [RateHistory newEntityObject:rateDict];
                                     NSLog(@"added new entity object   ---->>> from workingWithDB"); }                                                //    otherwise, creting new Entity object

        }
                                                        NSLog(@"writing to DB ended");
            block(@"Yes!");
    }];
                                                        NSLog(@"After parsing");
}
@end
