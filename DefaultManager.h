//
//  DefaultManager.h
//  MultyChoice
//
//  Created by Yuliia on 10.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultManager : NSObject

+(void)rememberAboutMainCurrency: (NSString *) mainCurrencyAbbreviation withKey: (NSString *) key;
+(BOOL)checkApplicationLaunch: (NSString *) key;
+(void)rememberAboutApplicationLaunchWithKey:(NSString *) key;
+(NSString *) recallAboutMainCurrencyUsingKey: (NSString*) key;

@end
