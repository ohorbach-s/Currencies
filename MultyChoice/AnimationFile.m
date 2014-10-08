//
//  AnimationFile.m
//  MultyChoice
//
//  Created by Yuliia on 06.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "AnimationFile.h"

@implementation AnimationFile
+ (void)shakeAnimation:(UITableViewCell*)cell {
    NSString *shakeAnimationKeyPath = @"position";
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:shakeAnimationKeyPath];
    [shake setDuration:0.1];
    [shake setRepeatCount:3];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:CGPointMake(cell.center.x - 5,
                                                              cell.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:CGPointMake(cell.center.x + 5,
                                                            cell.center.y)]];
    [cell.layer addAnimation:shake forKey:shakeAnimationKeyPath];
}
+(void) cellAnimation :(UITableViewCell *)cell {
    cell.layer.opacity = 1.8;
    [UIView animateWithDuration:0.7 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];
}
+ (void)addFallAnimationForLayer:(CALayer *)layer{
    NSString *keyPath = @"transform.rotation.y";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0;
    translation.repeatCount = 1;
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[NSNumber numberWithFloat:5.7f]];
    CGFloat height = [[UIScreen mainScreen] applicationFrame].size.height - layer.frame.size.height;
    [values addObject:[NSNumber numberWithFloat:height]];
    translation.values = values;
    translation.repeatCount = 1;
    translation.autoreverses = YES;
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    translation.timingFunctions = timingFunctions;
    [layer addAnimation:translation forKey:keyPath];
}

+(void)animateTableViewAppearance:(UITableView*)tableView{
    NSString *transitionKeyPath = @"UITableViewReloadDataAnimationKey";
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 0.7;
    transition.subtype = kCATransitionFromBottom;
    [[tableView layer] addAnimation:transition forKey:transitionKeyPath];
}


@end
