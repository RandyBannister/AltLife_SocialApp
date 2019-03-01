//
//  MobileVerification1.m
//  AltLife
//
//  Created by BradReed on 10/17/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "HomeViewController.h"
#import "MobileVerification1.h"
@import FirebaseAuth;
extern int ifSignUp;

@interface MobileVerification1 ()

@end
@implementation MobileVerification1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onRegister:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *verificationID = [defaults stringForKey:@"authVerificationID"];

    
    FIRPhoneAuthCredential *credential =
    [[FIRPhoneAuthProvider provider] credentialWithVerificationID:verificationID  verificationCode:_verificationCode.text];
    
    [[[FIRAuth auth] currentUser] linkWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error)
    {
            if(error)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Phone verification failed"                                                                       message:@"Please check the verification code again" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                }];
                [alert addAction:actAlert];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            else
            {
                HomeViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"hometabbar"];
                [self.navigationController pushViewController:apvc animated:YES];
                ifSignUp = 1;
            }
        }
        
     ];

}

- (IBAction)onBack:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
@end
