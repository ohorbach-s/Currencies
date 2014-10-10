//
//  AppLaunchDefaultManager.h
//  MultyChoice
//
//  Created by Yuliia on 10.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLaunchDefaultManager : NSObject

+(BOOL)checkApplicationLaunch;
+(void)rememberAboutApplicationLaunchWithKey;

@end
