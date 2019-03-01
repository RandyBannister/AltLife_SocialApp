//
//  UserAccountViewController.h
//  AltLife
//
//  Created by BradReed on 10/15/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface UserAccountViewController : UIViewController
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UIButton *caBtn;
@property (weak, nonatomic) IBOutlet UIButton *hookupBtn;
@property (weak, nonatomic) IBOutlet UIButton *bdsmBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
@property (weak, nonatomic) IBOutlet UIButton *swingbtn;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
- (IBAction)onCA:(id)sender;
- (IBAction)onHook:(id)sender;
- (IBAction)onTop:(id)sender;

- (IBAction)onBD:(id)sender;
- (IBAction)onBottom:(id)sender;
- (IBAction)onChat:(id)sender;
- (IBAction)onFri:(id)sender;
- (IBAction)onSw:(id)sender;



- (IBAction)onBack:(id)sender;
- (IBAction)onReport:(id)sender;

- (IBAction)onFollowing:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countOfFollower;
- (IBAction)onMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *explainText;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
- (IBAction)onFollow:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *countOfFollowing;
- (IBAction)onFollowers:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userLocation;
@end
