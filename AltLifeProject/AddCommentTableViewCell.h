//
//  AddCommentTableViewCell.h
//  AltLifeProject
//
//  Created by Mobile Star on 11/7/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *profileName;

@property (weak, nonatomic) IBOutlet UILabel *contentsText;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@end
