//
//  UsedData.h
//  MultyChoice
//
//  Created by Yuliia on 26.09.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsedData : NSObject
@property(nonatomic, strong) NSArray *shortNames;
@property(nonatomic, strong) NSArray *fullNames;
@property(nonatomic, strong) NSArray *flags;
-(id)initData;
@end
