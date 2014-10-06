//
//  AnimationFile.m
//  MultyChoice
//
//  Created by Yuliia on 06.10.14.
//  Copyright (c) 2014 Yuliia. All rights reserved.
//

#import "AnimationFile.h"

@implementation AnimationFile


+ (void)shakeAnimation:(UILabel*)label
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:1.1];
    [shake setRepeatCount:30];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:CGPointMake(label.center.x - 5,
                                                              label.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:CGPointMake(label.center.x + 5,
                                                            label.center.y)]];
    [label.layer addAnimation:shake forKey:@"position"];
}

+(void) cellAnimation :(UITableViewCell *)cell
{
        cell.layer.opacity = 1.8;
    [UIView animateWithDuration:0.7 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];

}
@end
