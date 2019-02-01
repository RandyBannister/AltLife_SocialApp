//
//  AddCommentTableViewCell.m
//  AltLifeProject
//
//  Created by Mobile Star on 11/7/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "AddCommentTableViewCell.h"

@implementation AddCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_contentsText sizeToFit];
 //   [self layoutIfNeeded];
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
