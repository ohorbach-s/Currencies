//
//  CurrencyInfo.m
//  MultyChoice
//
//  Created by Yuliia on 21.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "CurrencyInfo.h"
#import "RateHistory.h"
#import "MainViewController.h"
@implementation CurrencyInfo

@dynamic abbrev;
@dynamic fullName;
@dynamic icon;
@dynamic checked;

+ (void)firstCurrencyInfoInitialization {
    UsedData *getData = [[UsedData alloc] initData];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    for (int j = 0; j < [getData.shortNames count]; j++) {
        CurrencyInfo *newResult = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"CurrencyInfo"
                                   inManagedObjectContext:context];
        newResult.abbrev = [getData.shortNames objectAtIndex:j];
        newResult.fullName = [getData.fullNames objectAtIndex:j];
        newResult.icon = [getData.flags objectAtIndex:j];
        newResult.checked = 0;
        
        NSError *error;
        [context save:&error];
    }
}
+(void) setTheMainCurrency:(NSString*)mainName :(NSString*)fullName
                             :(NSString*)image :(MainViewController*)controller {
    controller.mainName.text = mainName;
    controller.mainFullName.text = fullName;
    controller.mainImage.image = [UIImage imageNamed:image];
}
@end
