//
//  MessageTableCell.m
//  AltLifeProject
//
//  Created by Mobile Star on 11/8/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "MessageTableCell.h"

@implementation MessageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    [_nameText sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
