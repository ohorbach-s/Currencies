//
//  ParcingYahoo.m
//  MultyChoice
//
//  Created by Admin on 15.09.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//
#import "RTAppDelegate.h"
#import "ParcingYahoo.h"
#import "RateHistory.h"
#import "Starter.h"
@implementation ParcingYahoo

-(id)init
{
    self = [super init];
    if(self){
        
      _shortNames = @[@"UAH", @"USD", @"EUR", @"GBP", @"PLN", @"CAD", @"AUD", @"JPY", @"CNY", @"XAU"];
    }
    
    return self;
}


- (void) convertUsdInto: (NSString*) currency withBlock:(void (^)(NSString *))block {
    
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    for (int j = 0; j < [_shortNames count]; j++) {
        NSURL* url;
        NSString* urlString = [NSString stringWithFormat:@"https://query.yahooapis.com/v1/public/yql?q=select%%20*%%20from%%20yahoo.finance.xchange%%20where%%20pair%%20in%%20(%%22USD%@%%22)&format=json&diagnostics=true&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", currency];
        
        url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data, NSError *connectionError)
         {
             
             if (data.length > 0 && connectionError == nil)
             {
                 NSDictionary* rateDict = [[[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]
                                             objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"rate"];
                 block([rateDict objectForKey:@"Rate"]);
             } else block (@"error");
         }];
        [context save:&error];
    }
}

-(void)refreshData
{
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"RateHistory"
                                    inManagedObjectContext: context]];
    NSError *error;
    NSArray *fetched = [context executeFetchRequest:request
                                              error:&error];
    
    RateHistory *exemplair = [fetched lastObject];
    NSDate *now = [NSDate date];
    
    NSUInteger count = [context countForFetchRequest: request
                                               error: &error];
    if (count > 7){
        [request setFetchLimit:1];
        NSArray *fetched = [context executeFetchRequest:request
                                                  error:&error];
        RateHistory *rateToDelete = fetched[0];
        [context deleteObject:rateToDelete];
        [context save:&error];
     } else {
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *strMyDate= [dateFormatter stringFromDate:now];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"RateHistory"
                                                       inManagedObjectContext:context];
        [request setEntity:entityDesc];
         
        NSArray *fetched = [context executeFetchRequest:request
                                                  error:&error];
        exemplair = [fetched lastObject];
        NSString *lastSaveString = [dateFormatter stringFromDate:exemplair.date];
        
        if([strMyDate isEqualToString:lastSaveString]){
            
    //requesting from yahoo and saving
            for (int j = 0; j < [_shortNames count]; j++){
              
             [self convertUsdInto: [_shortNames objectAtIndex:j] withBlock:^(NSString *rate) {
             [exemplair setValue:rate forKey:[[_shortNames objectAtIndex:j] lowercaseString]];// заповнюєм ентіті History джейсоном
             NSError *error;
             [context save:&error];
             }];
           }
        } else {
          RateHistory *newResult = [NSEntityDescription insertNewObjectForEntityForName:@"RateHistory"
                                                                 inManagedObjectContext:context];
          newResult.date = now;
            
          for (int j = 0; j < [_shortNames count]; j++) {
            [self convertUsdInto: [_shortNames objectAtIndex:j] withBlock:^(NSString *rate) {
            [newResult setValue:rate forKey:[[_shortNames objectAtIndex:j] lowercaseString]];// заповнюєм ентіті History джейсоном
            NSError *error;
            [context save:&error];
          }];
        }
           
    }
  }
     NSLog(@"After parsing");
}

@end
