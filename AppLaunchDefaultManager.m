//
//  AppLaunchDefaultManager.m
//  MultyChoice
//
//  Created by Yuliia on 10.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "AppLaunchDefaultManager.h"

static NSString *appLauchKey = @"HasLaunchedOnce";

@implementation AppLaunchDefaultManager
//check whether the application is launched for the first time
+(BOOL)checkApplicationLaunch {
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:appLauchKey];
    return result;
}
//setting the laucnh state  (for the first time or for n-time)
+(void)rememberAboutApplicationLaunchWithKey {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:appLauchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
