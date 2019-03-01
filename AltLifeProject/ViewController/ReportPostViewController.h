//
//  ReportPostViewController.h
//  AltLifeProject
//
//  Created by Mobile Star on 11/2/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface ReportPostViewController : UIViewController
- (IBAction)onBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageprofile1;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *imageName;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UITextField *reasonText;
@property (weak, nonatomic) IBOutlet UITextView *contentsText;
- (IBAction)onSubmit:(id)sender;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (nonatomic) NSString *selName;
@property (nonatomic) NSString *selID;
@property (nonatomic) NSString *selLocation;
@property (nonatomic) UIImage *pr1;
@property (nonatomic) UIImage *pr2;

@end
