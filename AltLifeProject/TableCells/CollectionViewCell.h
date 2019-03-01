//
//  CollectionViewCell.h
//  
//
//  Created by BradReed on 10/6/17.
//
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;

@end
