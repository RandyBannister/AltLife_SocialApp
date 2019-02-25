//
//  MobileVerification1.h
//  AltLife
//
//  Created by BradReed on 10/17/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileVerification1 : UIViewController
- (IBAction)onRegister:(id)sender;
- (IBAction)onBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;

@end
