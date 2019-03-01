//
//  AddCommentViewController.h
//  AltLifeProject
//
//  Created by Mobile Star on 11/2/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface AddCommentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleText;
- (IBAction)onBack:(id)sender;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileAgo;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *contentsText;
@property (weak, nonatomic) IBOutlet UILabel *countOfCommentsText;
@property (weak, nonatomic) IBOutlet UITextField *postComment;
- (IBAction)onSend:(id)sender;
@property (nonatomic) NSString *profileN;
@property (nonatomic) UIImage *profileI;
@property (nonatomic) NSString *profileA;
@property (nonatomic) NSString *profileC;
@property (nonatomic) NSString *profileT;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString *profileIDofDiscussion;


@end
