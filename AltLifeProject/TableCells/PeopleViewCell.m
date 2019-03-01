//
//  PeopleViewCell.m
//  AltLife
//
//  Created by BradReed on 10/12/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "PeopleViewCell.h"

@implementation PeopleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _stringText.lineBreakMode = NSLineBreakByWordWrapping;
    _stringText.numberOfLines = 0;
    _imageAvatar.layer.masksToBounds = YES;
    _imageAvatar.layer.cornerRadius = _imageAvatar.frame.size.width/2;
}

- (IBAction)onSeeprofile:(id)sender {
}
@end
