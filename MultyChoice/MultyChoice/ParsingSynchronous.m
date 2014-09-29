//
//  ParsingSynchronous.m
//  MultyChoice
//
//  Created by Yuliia on 27.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "ParsingSynchronous.h"
#import "RTAppDelegate.h"
#import "Starter.h"

@implementation ParsingSynchronous
- (NSMutableDictionary*) synchroniousConvert{                                 //implementing the synchronous request for the background update
    
    NSArray *returnedRate = nil;
    NSURL* url;
    
    NSString* urlString = [NSString stringWithFormat:@"https://query.yahooapis.com/v1/public/yql?q=select%%20*%%20from%%20yahoo.finance.xchange%%20where%%20pair%%20in%%20(%%22USDUAH%%22%%2C%%22USDUSD%%22%%2C%%22USDEUR%%22%%2C%%22USDGBP%%22%%2C%%22USDPLN%%22%%2C%%22USDCAD%%22%%2C%%22USDAUD%%22%%2C%%22USDJPY%%22%%2C%%22USDCNY%%22%%2C%%22USDXAU%%22)&format=json&diagnostics=true&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback="];
    url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data.length >0 && error == nil) {
        NSArray* rateDict = [[[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"rate"];
        returnedRate = rateDict;
    }
    if (error!=nil) {
        RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *error;
        NSFetchRequest *req = [NSFetchRequest new];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"RateHistory" inManagedObjectContext:context];
        [req setEntity:entityDesc];
        NSArray *fetched = [context executeFetchRequest:req error:&error];
        RateHistory *temp = [fetched lastObject];
        NSString *datestring = [NSString stringWithFormat:@"Data is valid for %@", temp.date];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Internet connection"
                                                          message:datestring
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return nil;
    }else{
        NSMutableDictionary *pairResult = [NSMutableDictionary new];
        for (NSDictionary *tmp in returnedRate) {
            NSString *newstrID = [tmp objectForKey:@"id"];
            NSString *strID = [newstrID substringFromIndex:3];
            NSString *newstrValue = [tmp objectForKey:@"Rate"];
            [pairResult setObject:newstrValue forKey:strID];
        }
        return pairResult;
    }
}

@end
