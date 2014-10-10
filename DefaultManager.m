//
//  DefaultManager.m
//  MultyChoice
//
//  Created by Yuliia on 10.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "DefaultManager.h"

@implementation DefaultManager

+(void)rememberAboutMainCurrency: (NSString *) mainCurrencyAbbreviation withKey: (NSString *) key {
    [[NSUserDefaults standardUserDefaults] setValue:mainCurrencyAbbreviation
                                             forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)checkApplicationLaunch: (NSString *) key {
    BOOL rezult = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return rezult;
}

+(void)rememberAboutApplicationLaunchWithKey:(NSString *) key {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) recallAboutMainCurrencyUsingKey: (NSString*) key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

@end
