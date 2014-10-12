//
//  AlertDisplay.m
//  MultyChoice
//
//  Created by Yuliia on 10.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "AlertDisplay.h"



@implementation AlertDisplay

+(void) noInternetAlertViewDisplay {
    DataBaseManager *dataBaseManager = [DataBaseManager sharedManager]; //// ????
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm"];
    
    NSDate *tempDate =
    [[dataBaseManager.fetchedRateHistory firstObject] date];
    NSString *abbrev = [[dataBaseManager.fetchedRateHistory firstObject] valueForKey:@"uah"];
    
    NSString *strMyDate = [dateFormatter stringFromDate:tempDate];
    
    if(abbrev!=nil){
        NSString *datestring = [NSString
                                stringWithFormat:@"Data is valid for %@", strMyDate];
        UIAlertView *message = [[UIAlertView alloc]
                                initWithTitle:@"No Internet connection"
                                message:datestring
                                delegate:nil
                                cancelButtonTitle:@"Okay"
                                otherButtonTitles:nil];
        [message show];
    } else
        [self emptyDataBaseAlertViewDisplay];
}

+(void) emptyDataBaseAlertViewDisplay {
    UIAlertView *message = [[UIAlertView alloc]
                            initWithTitle:@"No Internet connection"
                            message:@"The app is launched for the first time "
                            @"and Data source is empty"
                            delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                            otherButtonTitles:nil];
    [message show];
}

@end
