//
//  AnimationFile.m
//  MultyChoice
//
//  Created by Yuliia on 06.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "AnimationFile.h"

@implementation AnimationFile
//animated selected second table cell
+ (void)shakeAnimation:(UITableViewCell*)cell {
    NSString *shakeAnimationKeyPath = @"position";
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:shakeAnimationKeyPath];
    [shake setDuration:0.1];
    [shake setRepeatCount:3];
    [shake setAutoreverses:YES];
    CABasicAnimation *makeBiggerAnim=[CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    makeBiggerAnim.fromValue=[NSNumber numberWithDouble:20.0];
    makeBiggerAnim.toValue=[NSNumber numberWithDouble:40.0];
    
    CABasicAnimation *fadeAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue=[NSNumber numberWithDouble:1.0];
    fadeAnim.toValue=[NSNumber numberWithDouble:0.0];
    
    CABasicAnimation *rotateAnim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotateAnim.fromValue=[NSNumber numberWithDouble:0.0];
    rotateAnim.toValue=[NSNumber numberWithDouble:M_PI_4];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.1;
    group.repeatCount = 1;
    group.autoreverses = YES;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = [NSArray arrayWithObjects:makeBiggerAnim, fadeAnim, rotateAnim, shake, nil];
    
    [cell.layer addAnimation:group forKey:@"allMyAnimations"];
}
//animate selected main currency
+ (void)addRotateAnimationForLayer:(CALayer *)layer{
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
    translation.speed = 0.005;
    translation.autoreverses = YES;
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    //[timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    translation.timingFunctions = timingFunctions;
    [layer addAnimation:translation forKey:keyPath];
}
//animated second table appearance
+(void)displaySecondTable:(UITableViewCell *)cell :(NSIndexPath *)indexPath {
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(20, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(1, 5.5);
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.7];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 3;
    cell.layer.shadowOffset = CGSizeMake(5, 0);
    [UIView commitAnimations];
}

//animated main table 'fall' effect
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
