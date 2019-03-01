//
//  PostAds.m
//  AltLife
//
//  Created by BradReed on 10/15/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "PostAds.h"
@import FirebaseAuth;
@import Firebase;
@interface PostAds (){
    NSMutableArray * cateArray;
}

@end

@implementation PostAds


int array_cate[] = {-1,-1,-1,-1,-1,-1};
extern UIImage *myProfileImage;
extern NSString *nameMyProfile, *locationMyProfile;

UIImage *imagePost;
- (void)viewDidLoad {
    [super viewDidLoad];
    for(int i=0;i<6;i++)
        array_cate[i] = -1;
    cateArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [_nameText setText:nameMyProfile];
    [_locationText setText:locationMyProfile];
    _commentTxtView.text = @"Write something...";
    _commentTxtView.textColor = [UIColor lightGrayColor];
    _commentTxtView.delegate = self;
    [_profileImage setImage:myProfileImage];
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    [_commentTxtView setDelegate:self];
    [_titleText setDelegate:self];
    self.ref = [[FIRDatabase database] reference];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
}
-(void) dismiss{
    [_titleText resignFirstResponder];
    [_commentTxtView resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _commentTxtView.text = @"";
    _commentTxtView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_commentTxtView.text.length == 0){
        _commentTxtView.textColor = [UIColor lightGrayColor];
        _commentTxtView.text = @"Write something...";
        [_commentTxtView resignFirstResponder];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBack:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
- (IBAction)onPostImage:(id)sender {
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
    imagePost = chosenImage;
    [_postImage setImage:imagePost forState:UIControlStateNormal];
//    [self.profileImage setImage:chosenImage];
//    myProfileImage = chosenImage;
    [_postImage.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [_postImage.layer setBorderWidth:5.0];
    
//    [_cameraButton setHidden:YES];
    self.postImage.layer.masksToBounds = YES;
    self.postImage.layer.cornerRadius = self.postImage.frame.size.width/2;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSubmit:(id)sender {
    for(int i=0;i<6;i++)
        [cateArray addObject:[NSNumber numberWithInt:array_cate[i]]];
    FIRUser * user = [FIRAuth auth].currentUser;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-07:00"]];
    NSDate * timeNow = [NSDate date];
    
    NSString *stringTime = [dateFormatter stringFromDate:timeNow];
    [[[[_ref child:@"Posts"] child:user.uid] child: stringTime] setValue:@{@"Title": _titleText.text}];
    [[[[[_ref child:@"Posts"] child:user.uid] child:stringTime] child:@"Comment"]
     setValue:_commentTxtView.text];
    [[[[[_ref child:@"Posts"] child:user.uid] child:stringTime] child:@"Category"]
     setValue:cateArray];

    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    
    NSData *data = UIImagePNGRepresentation(imagePost);
    NSString *filename = [stringTime stringByAppendingString:@".PNG"];
    
    
    NSString *uploadURL = [user.uid stringByAppendingString:@"/"];
    uploadURL = [uploadURL stringByAppendingString:filename];
    
    FIRStorageReference *riversRef = [storageRef child:uploadURL];
    
    // Upload the file to the path "images/rivers.jpg"
    FIRStorageUploadTask *uploadTask = [riversRef putData:data
                                                 metadata:nil
                                               completion:^(FIRStorageMetadata *metadata,
                                                            NSError *error) {
                                                   if (error != nil) {
                                                       
                                                       
                                                   } else {
                                                       
                                                       NSURL *downloadURL = metadata.downloadURL;
                                                       UINavigationController *navigationController = self.navigationController;
                                                       [navigationController popViewControllerAnimated:YES];
                                                   }
                                               }];
    
    
}


- (IBAction)onmenforwomen:(id)sender {
    if(array_cate[0] == -1)
        [_menforwomen setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
    else if(array_cate[0] == 1)
        [_menforwomen setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    array_cate[0] *= -1;
}
- (IBAction)onwomenformen:(id)sender {
    if(array_cate[1] == -1)
        [_womenformen setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
    else if(array_cate[1] == 1)
        [_womenformen setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    array_cate[1] *= -1;
}
- (IBAction)ontsformen:(id)sender {
    if(array_cate[2] == -1)
        [_tsformen setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
    else if(array_cate[2] == 1)
        [_tsformen setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    array_cate[2] *= -1;
}
- (IBAction)onmenformen:(id)sender {
    if(array_cate[3] == -1)
        [_menformen setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
    else if(array_cate[3] == 1)
        [_menformen setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    array_cate[3] *= -1;
}
- (IBAction)onwomenforwomen:(id)sender {
    if(array_cate[4] == -1)
        [_womenforwomen setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
    else if(array_cate[4] == 1)
        [_womenforwomen setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    array_cate[4] *= -1;
}
- (IBAction)onfetish:(id)sender {
    if(array_cate[4] == -1)
        [_fetish setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
    else if(array_cate[4] == 1)
        [_fetish setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    array_cate[5] *= -1;
}

@end
