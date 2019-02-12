//
//  ViewController.h
//  
//
//  Created by BradReed on 10/13/17.
//
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) FIRDatabaseReference *ref;

- (IBAction)onSignUp:(id)sender;
- (IBAction)onLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@end
