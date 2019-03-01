//
//  CatTableViewCell.h
//  AltLife
//
//  Created by BradReed on 10/6/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cateTitile;
@property (weak, nonatomic) IBOutlet UILabel *countOfListing;
@property (weak, nonatomic) IBOutlet UIImageView *cateImage;

@end
