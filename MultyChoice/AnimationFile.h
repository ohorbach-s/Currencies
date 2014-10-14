//
//  AnimationFile.h
//  MultyChoice
//
//  Created by Yuliia on 06.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationFile : NSObject

@property (assign, nonatomic) CATransform3D initialTransformation;
@property (nonatomic, strong) NSMutableSet *shownIndexes;
+(void)shakeAnimation:(UITableViewCell*)cell;
+(void)displaySecondTable:(UITableViewCell *)cell :(NSIndexPath *)indexPath;
+ (void)addRotateAnimationForLayer:(CALayer *)layer;
+(void)animateTableViewAppearance:(UITableView*)tableView;
@end
