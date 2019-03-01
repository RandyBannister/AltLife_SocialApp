//
//  DisTableViewCell.m
//  AltLife
//
//  Created by BradReed on 10/7/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "DisTableViewCell.h"

@implementation DisTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _textDis.lineBreakMode = NSLineBreakByWordWrapping;
    _textDis.numberOfLines = 0;
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onLike:(id)sender {
}

- (IBAction)onComment:(id)sender {
}
@end
