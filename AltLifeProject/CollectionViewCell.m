//
//  CollectionViewCell.m
//  
//
//  Created by BradReed on 10/6/17.
//
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _postText.lineBreakMode = NSLineBreakByWordWrapping;
    _postText.numberOfLines = 0;
    _avatarImage.layer.masksToBounds = YES;
    _avatarImage.layer.cornerRadius = _avatarImage.frame.size.width/2;
}

@end
