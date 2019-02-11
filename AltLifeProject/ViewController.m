//
//  ViewController.m
//  
//
//  Created by BradReed on 10/13/17.
//
//

#import "ViewController.h"
#import "SignUpClassViewController.h"
#import "HomeViewController.h"
@import Firebase;
@import FirebaseAuth;

extern NSArray *followerPeople;
extern NSArray *followingPeople;
extern int paidMyProfile;
extern UIImage *myProfileImage;
extern NSString *nameMyProfile, *locationMyProfile;
extern NSArray *interestingList;
extern NSString *explainString;
extern int privateModeMyProfile;
extern NSNumber* followersMyProfile, *followingMyProfile;
extern NSString *Curemail, *Curpwd;
extern int firstLogin;

@interface ViewController (){
    FIRAuthStateDidChangeListenerHandle handle;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    [_emailText setDelegate:self];
    [_pwdText setDelegate:self];
    myProfileImage = [UIImage imageNamed:@"profilep.PNG"];
    
    self.ref = [[FIRDatabase database] reference];
    
    

    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    [[FIRAuth auth] removeAuthStateDidChangeListener:handle];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    handle = [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       // ...
                   }];
    
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSignUp:(id)sender {
    SignUpClassViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpView"];
    [self.navigationController pushViewController:apvc animated:YES];
}

- (IBAction)onLogin:(id)sender {
    
    
    //Sign in
    [[FIRAuth auth] signInWithEmail:_emailText.text
                           password:_pwdText.text
                         completion:^(FIRUser *user, NSError *error) {
                             if(error)
                                 return;
                             Curemail = _emailText.text;
                             Curpwd = _pwdText.text;
                             FIRStorage *storage = [FIRStorage storage];
                             FIRStorageReference *storageRef = [storage reference];
                             NSString *downURL = [user.uid stringByAppendingString: @"/profileImage.PNG"];
                             FIRStorageReference *islandRef = [storageRef child:downURL];
                             
                             // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                             [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                                 if (error != nil) {
                                     // Uh-oh, an error occurred!
                                 } else {
                                     // Data for "images/island.jpg" is returned
                                     UIImage *islandImage = [UIImage imageWithData:data];
                                     myProfileImage = islandImage;
                                     
                                     
                                 }
                             }];
                             
                             
                             [[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                 NSDictionary *postDict = snapshot.value;
                                 // ...
                                 nameMyProfile = [postDict objectForKey:@"name"];
                                 explainString = [postDict objectForKey:@"explain"];
                                 locationMyProfile = [postDict objectForKey:@"location"];
                                 interestingList = [postDict objectForKey:@"interesting"];
                                 NSNumber *isPaid = [postDict objectForKey:@"isPaid"];
                                 
                                 paidMyProfile = [isPaid integerValue];
                                 followersMyProfile = [postDict objectForKey:@"followers"];
                                 followingMyProfile = [postDict objectForKey:@"following"];
 
                                 followingPeople = [postDict objectForKey:@"followingPeople"];
                                 followerPeople = [postDict objectForKey:@"followerPeople"];
                                 
                                 privateModeMyProfile = [[postDict objectForKey:@"private"] intValue];
                                
                                 HomeViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"hometabbar"];
                                 [self.navigationController pushViewController:apvc animated:YES];
                                 
                                 NSLog(@"Success!");
                                 
                             }];

                             
                             // If login success!!!

                             
                             
                             
                             
                         }];
    

}
@end
