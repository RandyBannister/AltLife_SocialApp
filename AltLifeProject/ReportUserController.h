//
//  ReportUserController.h
//  AltLifeProject
//
//  Created by Mobile Star on 11/2/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface ReportUserController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UIButton *onBack;
- (IBAction)BackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *reasonText;
@property (weak, nonatomic) IBOutlet UITextView *contentsText;
- (IBAction)onSubmit:(id)sender;
@property (nonatomic)  NSString *name;
@property (nonatomic)  NSString *location;
@property (nonatomic)  UIImage  *profileimg;
@property (nonatomic)  NSString  *selID;
@property (strong, nonatomic) FIRDatabaseReference *ref;


@end
