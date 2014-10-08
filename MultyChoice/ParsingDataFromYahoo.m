//
//  ParcingYahoo.m
//  MultyChoice
//
//  Created by Admin on 15.09.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//
#import "AppDelegate.h"
#import "ParsingDataFromYahoo.h"
#import "RateHistory.h"

@implementation ParsingDataFromYahoo

// implementing the asynchronous request for the manual update
+ (void)asynchronousRequestWithcompletionHandler:(void (^)(NSMutableDictionary *))completionHandler {
    DataBaseManager *dataBaseManager = [DataBaseManager sharedManager];
    NSURL *url;
    NSString *urlString = [NSString
                           stringWithFormat:@"https://query.yahooapis.com/v1/public/"
                           @"yql?q=select%%20*%%20from%%20yahoo.finance.xchange%%"
                           @"20where%%20pair%%20in%%20(%%22USDUAH%%22%%2C%%"
                           @"22USDUSD%%22%%2C%%22USDEUR%%22%%2C%%22USDGBP%%22%%2C%"
                           @"%22USDPLN%%22%%2C%%22USDCAD%%22%%2C%%22USDAUD%%22%%"
                           @"2C%%22USDJPY%%22%%2C%%22USDCNY%%22%%2C%%22USDXAU%%22)"
                           @"&format=json&diagnostics=true&env=store%%3A%%2F%%"
                           @"2Fdatatables.org%%2Falltableswithkeys&callback="];
    url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data,
                         NSError *connectionError) {
         
         if (data.length > 0 && connectionError == nil) {
             NSArray *rateDict =
             [[[[NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:NULL]
                objectForKey:@"query"] objectForKey:@"results"]
              objectForKey:@"rate"];
             
             NSMutableDictionary *pairResult = [NSMutableDictionary new];
             for (NSDictionary *tmp in rateDict) {
                 NSString *newstrID = [tmp objectForKey:@"id"];
                 NSString *strID = [newstrID substringFromIndex:3];
                 NSString *newstrValue = [tmp objectForKey:@"Rate"];
                 [pairResult setObject:newstrValue forKey:strID];
             }
             completionHandler(pairResult);
         } else {
             NSDateFormatter *dateFormatter = [NSDateFormatter new];
             [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm"];
             
             NSDate *tempDate =
             [[dataBaseManager.fetchedRateHistory firstObject] date];
             
             NSString *strMyDate = [dateFormatter stringFromDate:tempDate];
             
             if (tempDate == nil) {
                 UIAlertView *message = [[UIAlertView alloc]
                                         initWithTitle:@"No Internet connection"
                                         message:nil
                                         delegate:nil
                                         cancelButtonTitle:@"Okay :C"
                                         otherButtonTitles:nil];
                 [message show];
                 
             } else {
                 NSString *datestring = [NSString
                                         stringWithFormat:@"Data is valid for %@", strMyDate];
                 UIAlertView *message = [[UIAlertView alloc]
                                         initWithTitle:@"No Internet connection"
                                         message:datestring
                                         delegate:nil
                                         cancelButtonTitle:@"Okay"
                                         otherButtonTitles:nil];
                 [message show];
             }
             completionHandler(nil);
         }
     }];
}
// implementing the synchronous request for the background update
+ (NSMutableDictionary*)synchronousRequest {
    
    NSArray* returnedRate = nil;
    NSURL* url;
    NSMutableDictionary* pairResult = [NSMutableDictionary new];
    NSString* urlString = [NSString
                           stringWithFormat:@"https://query.yahooapis.com/v1/public/"
                           @"yql?q=select%%20*%%20from%%20yahoo.finance.xchange%%"
                           @"20where%%20pair%%20in%%20(%%22USDUAH%%22%%2C%%"
                           @"22USDUSD%%22%%2C%%22USDEUR%%22%%2C%%22USDGBP%%22%%2C%"
                           @"%22USDPLN%%22%%2C%%22USDCAD%%22%%2C%%22USDAUD%%22%%"
                           @"2C%%22USDJPY%%22%%2C%%22USDCNY%%22%%2C%%22USDXAU%%22)"
                           @"&format=json&diagnostics=true&env=store%%3A%%2F%%"
                           @"2Fdatatables.org%%2Falltableswithkeys&callback="];
    url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (data.length > 0 && error == nil) {
        NSArray* rateDict =
        [[[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]
           objectForKey:@"query"] objectForKey:@"results"]
         objectForKey:@"rate"];
        returnedRate = rateDict;
        for (NSDictionary* tmp in returnedRate) {
            NSString* newstrID = [tmp objectForKey:@"id"];
            NSString* strID = [newstrID substringFromIndex:3];
            NSString* newstrValue = [tmp objectForKey:@"Rate"];
            [pairResult setObject:newstrValue forKey:strID];
        }
    }
    return pairResult;
}

@end
