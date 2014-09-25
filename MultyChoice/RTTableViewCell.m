//
//  RTTableViewCell.m
//  MultyChoice
//
//  Created by Admin on 12.09.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "RTTableViewCell.h"

@implementation RTTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
