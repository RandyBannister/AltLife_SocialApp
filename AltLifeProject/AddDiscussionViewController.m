//
//  AddDiscussionViewController.m
//  AltLifeProject
//
//  Created by Mobile Star on 11/2/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "AddDiscussionViewController.h"

@interface AddDiscussionViewController ()

@end

@implementation AddDiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;


    // Do any additional setup after loading the view.
}

-(void) dismiss{
    [_titleText resignFirstResponder];
    [_contentsText resignFirstResponder];
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
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [_titleText resignFirstResponder];
    [_contentsText resignFirstResponder];
    return YES;
}
- (IBAction)onBack:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
- (IBAction)onSubmit:(id)sender {
//    [[[_ref child:@"Discussion"] child:[FIRAuth auth].currentUser.uid]
//     setValue:@{@"name": @"aaa"}];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-07:00"]];
    NSDate * timeNow = [NSDate date];
    NSString *stringTime = [dateFormatter stringFromDate:timeNow];
    
    stringTime = [[FIRAuth auth].currentUser.uid stringByAppendingString:stringTime];
    
    if(_titleText.text.length != 0 && _contentsText.text.length!=0)
    {
        [[[[_ref child:@"Discussion"] child:stringTime] child:@"title"] setValue:_titleText.text];
        [[[[_ref child:@"Discussion"] child:stringTime] child:@"contents"] setValue:_contentsText.text];
        UINavigationController *navigationController = self.navigationController;
        [navigationController popViewControllerAnimated:YES];
    }
}
@end
