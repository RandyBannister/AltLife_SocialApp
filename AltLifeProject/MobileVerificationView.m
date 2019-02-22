//
//  MobileVerificationView.m
//  
//
//  Created by BradReed on 10/17/17.
//
//

#import "MobileVerificationView.h"
#import "MobileVerification1.h"

@import FirebaseAuth;

@interface MobileVerificationView ()

@end

@implementation MobileVerificationView

- (void)viewDidLoad {
    [super viewDidLoad];
    [FIRAuth auth].languageCode = @"en";

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
- (IBAction)onSubmit:(id)sender {
    
    [[FIRPhoneAuthProvider provider] verifyPhoneNumber:_phonenumber.text
                                            UIDelegate:nil
                                            completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
                                                if (error)
                                                {
                                                    NSLog(@"%@", error.localizedDescription);
                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Phone `verification failed"                                                                       message:@"Please check your number again." preferredStyle:UIAlertControllerStyleActionSheet];
                                                    UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                    }];
                                                    [alert addAction:actAlert];
                                                    [self presentViewController:alert animated:YES completion:nil];
                                                    
                                                        
                                                    //[self showMessagePrompt:error.localizedDescription];
                                                    return;
                                                }
                                                // Sign in using the verificationID and the code sent to the user
                                                // ...
                                                MobileVerification1* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"mobileverification2"];
                                                [self.navigationController pushViewController:apvc animated:YES];

                                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                [defaults setObject:verificationID forKey:@"authVerificationID"];
                                                
                                                //  NSString *verificationID = [defaults stringForKey:@"authVerificationID"];
                                                
                                                
                                            }];

}

- (IBAction)onBack:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
@end
