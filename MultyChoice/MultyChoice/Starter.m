//
//  Starter.m
//  MultyChoice
//
//  Created by Yuliia on 19.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//
//
//#import "Starter.h"
//
//@implementation Starter
//-(void)firstLoad
//{                                                                          // fill the DB when the app is launched for the first time
//    ParcingYahoo *parser = [ParcingYahoo new];
//    [CurrencyInfo createMe];                      //creating currency information entity
//    NSLog(@"created currency info");
//
//    [ParsingDataFromYahoo convertwithBlock:^(NSMutableDictionary* rateDict)                                              //implementing the asynchronous request to fill the rate entity
//{
//        if (rateDict != nil)
//       {
//            [RateHistory newEntityObject:rateDict];                                                        //filling the rate entity
//                                                         NSLog(@"...and rate history created");
//       } else {                                                                                            // in case there is no internet connection available =D
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Internet connection"
//                                                              message:@"The app is launched for the first time and Data source is empty"
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"OK"
//                                                    otherButtonTitles:nil];
//        [message show];                                                                                    //displaynig the relevant alert
//
//          
//       }
//}];
// 
//}
//
//@end
