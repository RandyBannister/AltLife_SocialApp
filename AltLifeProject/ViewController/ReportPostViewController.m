//
//  ReportPostViewController.m
//  AltLifeProject
//
//  Created by Mobile Star on 11/2/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "ReportPostViewController.h"

@interface ReportPostViewController ()

@end

@implementation ReportPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];   // Set Firebase Dababase handle.
    
    [_imageProfile setImage:_pr1];
    [_imageprofile1 setImage:_pr2];
    [_imageName setText:_selName];
    [_locationText setText:_selLocation];
    _imageprofile1.layer.masksToBounds = YES;
    _imageprofile1.layer.cornerRadius = _imageprofile1.frame.size.width/2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
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

-(void) dismiss{
    [_reasonText resignFirstResponder];
    [_contentsText resignFirstResponder];
}

- (IBAction)onBack:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [_contentsText resignFirstResponder];
    [_reasonText resignFirstResponder];
    return YES;
}
- (IBAction)onSubmit:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-07:00"]];
    NSDate * timeNow = [NSDate date];
    
    NSString *stringTime = [dateFormatter stringFromDate:timeNow];

    
    [[[[[_ref child:@"ReportPost"] child:[FIRAuth auth].currentUser.uid] child:stringTime]
      child:@"title"] setValue:_reasonText.text];
    [[[[[_ref child:@"ReportPost"] child:[FIRAuth auth].currentUser.uid] child:stringTime]
      child:@"contents"] setValue:_contentsText.text];
    [[[[[_ref child:@"ReportPost"] child:[FIRAuth auth].currentUser.uid] child:stringTime]
      child:@"ID"] setValue:self.selID];
    
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
@end
