//
//  RTTableViewCell.h
//  MultyChoice
//
//  Created by Admin on 12.09.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *sumLabel;
@property (nonatomic, weak) IBOutlet UIImageView *flagImageView;

@end
