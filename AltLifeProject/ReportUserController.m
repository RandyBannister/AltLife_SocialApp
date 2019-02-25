//
//  ReportUserController.m
//  AltLifeProject
//
//  Created by Mobile Star on 11/2/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "ReportUserController.h"

@interface ReportUserController ()

@end

@implementation ReportUserController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.ref = [[FIRDatabase database] reference];   // Set Firebase
    // Do any additional setup after loading the view.
    _nameText.text = _name;
    _locationText.text = _location;
    [_profileImage setImage:_profileimg];
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.cornerRadius = _profileImage.layer.frame.size.width/2;
    [_profileImage.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [_profileImage.layer setBorderWidth:5.0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;

}
-(void) dismiss{
    [_reasonText resignFirstResponder];
    [_contentsText resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [_reasonText resignFirstResponder];
    [_contentsText resignFirstResponder];
    return YES;
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-07:00"]];
    NSDate * timeNow = [NSDate date];
    
    NSString *stringTime = [dateFormatter stringFromDate:timeNow];
    
    
    [[[[[_ref child:@"ReportUser"] child:[FIRAuth auth].currentUser.uid] child:stringTime]
      child:@"title"] setValue:_reasonText.text];
    [[[[[_ref child:@"ReportUser"] child:[FIRAuth auth].currentUser.uid] child:stringTime]
      child:@"contents"] setValue:_contentsText.text];
    [[[[[_ref child:@"ReportUser"] child:[FIRAuth auth].currentUser.uid] child:stringTime]
      child:@"ID"] setValue:self.selID];
    
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
- (IBAction)BackButton:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
@end
