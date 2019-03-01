//
//  PostAds.h
//  AltLife
//
//  Created by BradReed on 10/15/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseDatabase;

@interface PostAds : UIViewController <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *commentTxtView;
- (IBAction)onBack:(id)sender;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)onPostImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *postImage;
- (IBAction)onSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *menforwomen;
- (IBAction)onmenforwomen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *womenformen;
- (IBAction)onwomenformen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tsformen;
- (IBAction)ontsformen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *menformen;
- (IBAction)onmenformen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *womenforwomen;
- (IBAction)onwomenforwomen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fetish;
- (IBAction)onfetish:(id)sender;

@end
