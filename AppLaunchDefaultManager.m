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

+(BOOL)checkApplicationLaunch {
    BOOL rezult = [[NSUserDefaults standardUserDefaults] boolForKey:appLauchKey];
    return rezult;
}

+(void)rememberAboutApplicationLaunchWithKey {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:appLauchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
