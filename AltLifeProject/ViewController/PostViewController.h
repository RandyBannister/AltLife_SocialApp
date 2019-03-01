//
//  PostViewController.h
//  AltLifeProject
//
//  Created by Mobile Star on 10/27/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;


@interface PostViewController : UIViewController

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UIImageView *imagePost;
- (IBAction)onMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *textName;
@property (weak, nonatomic) IBOutlet UILabel *textLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonWM;
@property (weak, nonatomic) IBOutlet UIButton *buttonMW;
@property (weak, nonatomic) IBOutlet UIButton *buttonMM;
@property (weak, nonatomic) IBOutlet UIButton *buttonWW;
@property (weak, nonatomic) IBOutlet UIButton *buttonTM;
@property (weak, nonatomic) IBOutlet UIButton *buttonFB;
@property (weak, nonatomic) IBOutlet UILabel *textPost;
@property (weak, nonatomic) IBOutlet UILabel *textContent;
@property (weak, nonatomic) IBOutlet UILabel *textHours;

@property ( nonatomic)  UIImage *profilePreIm;
@property ( nonatomic)  UIImage *postPreIm;


- (IBAction)onBack:(id)sender;
- (IBAction)onReportPost:(id)sender;

@end
