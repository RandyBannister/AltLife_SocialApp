//
//  SignUpClassViewController.m
//  AltLife
//
//  Created by BradReed on 10/3/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "SignUpClassViewController.h"
#import "ViewController.h"
#import "MobileVerificationView.h"
#import "TermsAndConditionsViewController.h"
@import FirebaseAuth;
@import Firebase;

extern UIImage * myProfileImage;
extern NSString * nameMyProfile;
extern int privateModeMyProfile;
extern NSString *Curemail, *Curpwd;


@interface SignUpClassViewController ()

@end

@implementation SignUpClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_emailText setDelegate:self];
    [_pwdConfirmText setDelegate:self];
    [_pwdText setDelegate:self];
    [_nameText setDelegate:self];
    self.ref = [[FIRDatabase database] reference];
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

- (IBAction)onLogin:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];

}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)onSignUp:(id)sender {
    if(_pwdText.text != _pwdConfirmText.text){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password not matched" message:@"Please make sure the password is matched!" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            
        }];
        [alert addAction:actAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if(_emailText.text.length==0 || _pwdText.text.length == 0 || _pwdConfirmText.text.length == 0 || _nameText.text.length ==0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fill the textfield." message:@"Please make sure you did fill the all field." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            
        }];
        [alert addAction:actAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else{
    [[FIRAuth auth] createUserWithEmail:_emailText.text
                               password:_pwdText.text
                             completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                                 // ...
                                 if(error != nil){
                                    
                                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:[error  .userInfo valueForKey:@"NSLocalizedFailureReason"]
                                        message:[error.userInfo valueForKey:@"NSLocalizedDescription"]                                   preferredStyle:UIAlertControllerStyleActionSheet];
                                     UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                         
                                         
                                     }];
                                     [alert addAction:actAlert];
                                     [self presentViewController:alert animated:YES completion:nil];
                                 }
                                 else{
                                     NSLog(@"Success!");
                                     Curemail = _emailText.text;
                                     Curpwd = _pwdText.text;
                                     nameMyProfile = _nameText.text;
                                     FIRStorage *storage = [FIRStorage storage];
                                     FIRStorageReference *storageRef = [storage reference];
                                     if(myProfileImage!=nil)
                                     {
                                     NSData *data = UIImagePNGRepresentation(myProfileImage);
                                     
                                     NSString *uploadURL = [user.uid stringByAppendingString:@"/profileImage.PNG"];
                                     
                                     FIRStorageReference *riversRef = [storageRef child:uploadURL];
                                     
                                     // Upload the file to the path "images/rivers.jpg"
                                     FIRStorageUploadTask *uploadTask = [riversRef putData:data
                                                                                  metadata:nil
                                                                                completion:^(FIRStorageMetadata *metadata,
                                                                                             NSError *error) {
                                                                                    if (error != nil) {
                                                                                        
                                                                                        
                                                                                    } else {
                                                                                        
                                                                                        NSURL *downloadURL = metadata.downloadURL;
                                                                                    }
                                                                                }];

                                     }
                                     NSNumber *followingCount =[NSNumber numberWithInt:0];
                                     NSNumber *followerCount =[NSNumber numberWithInt:0];
                                     NSNumber *isPrivate =[NSNumber numberWithInt:-1];
                                     
                                    //Save the information to Firebase
                                     [[[_ref child:@"users"] child:user.uid]
                                      setValue:@{@"name": _nameText.text}];

                                     [[[[_ref child:@"users"] child:user.uid] child:@"following"]
                                         setValue:followingCount];
                                     [[[[_ref child:@"users"] child:user.uid] child:@"followers"] setValue:followerCount];
                                     [[[[_ref child:@"users"] child:user.uid] child:@"private"] setValue:isPrivate];
                                     
                                     [[[[_ref child:@"users"] child:user.uid] child:@"isPaid"] setValue:[NSNumber numberWithInt:0]];
                                     
                                     TermsAndConditionsViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"termsandconditions"];
                                     [self.navigationController pushViewController:apvc animated:YES];

                                     
                                 }
                             }];

    }
}

- (IBAction)onTakePhoto:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose"                                                               message:@"Please choose one." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Take a new photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }];
    UIAlertAction *actAlert1 = [UIAlertAction actionWithTitle:@"Choose from existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];

    [alert addAction:actAlert];    [alert addAction:actAlert1];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.profileImage setImage:chosenImage];
    myProfileImage = chosenImage;
    [_profileImage.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [_profileImage.layer setBorderWidth:3.0];
    
    [_cameraButton setHidden:YES];
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
