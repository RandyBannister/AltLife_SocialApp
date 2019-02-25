//
//  PostViewController.m
//  AltLifeProject
//
//  Created by Mobile Star on 10/27/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "PostViewController.h"
#import "ReportPostViewController.h"
#import "ChatUIViewController.h"

@interface PostViewController ()

@end
extern NSString *selectedID, *selectedTitle, *selectedComment, *selectedDate;
extern UIImage *selectedProfileImage, *selectedPostImage;
extern NSArray *selectedCategory;

FIRDatabaseHandle handle_post;

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageProfile.layer.masksToBounds = YES;
    self.imageProfile.layer.cornerRadius = _imageProfile.frame.size.width/2;
    self.ref = [[FIRDatabase database] reference];
    [_textContent sizeToFit];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-07:00"]];
    
    NSDate *date = [dateFormatter dateFromString:selectedDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date toDate:[NSDate date] options:0];
    
    NSLog(@"%ld, %ld, %ld, %ld, %ld, %ld, %ld", [components year], [components month], [components weekOfMonth], [components day], [components hour], [components minute], [components second]);
    
    NSString *agoString;
    if([components year]!=0)
    {
        if([components year] == 1)
            agoString = [NSString stringWithFormat:@"%ld year ago",[components year]];
        else
            agoString = [NSString stringWithFormat:@"%ld years ago",[components year]];
    }
    else
    {
        if([components month] != 0)
        {
            if([components month] == 1)
                agoString = [NSString stringWithFormat:@"%ld month ago",[components month]];
            else
                agoString = [NSString stringWithFormat:@"%ld months ago",[components month]];
        }
        else{
            if([components weekOfMonth] != 0)
            {
                if([components weekOfMonth] == 1)
                    agoString = [NSString stringWithFormat:@"%ld week ago",[components weekOfMonth]];
                else
                    agoString = [NSString stringWithFormat:@"%ld weeks ago",[components weekOfMonth]];
            }
            else{
                if([components day] != 0)
                {
                    if([components day] == 1)
                        agoString = [NSString stringWithFormat:@"%ld day ago",[components day]];
                    else
                        agoString = [NSString stringWithFormat:@"%ld days ago",[components day]];
                }
                else{
                    if([components hour]!=0)
                    {
                        if([components hour] == 1)
                            agoString = [NSString stringWithFormat:@"%ld hour ago",[components hour]];
                        else
                            agoString = [NSString stringWithFormat:@"%ld hours ago",[components hour]];
                    }
                    else{
                        if([components minute] != 0)
                        {
                            if([components minute] == 1)
                                agoString = [NSString stringWithFormat:@"%ld minute ago",[components minute]];
                            else
                                agoString = [NSString stringWithFormat:@"%ld minutes ago",[components minute]];
                        }
                        else{
                            if([components second] != 0)
                            {
                                if([components second] == 1)
                                    agoString = [NSString stringWithFormat:@"%ld second ago",[components second]];
                                else
                                    agoString = [NSString stringWithFormat:@"%ld seconds ago",[components second]];

                            }
                        }
                    }
                }
                
            }
        }
    }
    [_textHours setText:agoString];
//    NSDate * timeNow = [NSDate date];
    
//    NSString *stringTime = [dateFormatter stringFromDate:timeNow];
    
    
    [[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        // ...
        _textName.text = [postDict objectForKey:@"name"];
        _textLocation.text = [postDict objectForKey:@"location"];
        NSLog(@"Success!");
        
    }];
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    NSString *downURL;
    
    if(_postPreIm != nil)
       [_imagePost setImage:_postPreIm];
    else{
        

    downURL = [selectedID stringByAppendingString: @"/"];
    downURL = [downURL stringByAppendingString: selectedDate];
    downURL = [downURL stringByAppendingString: @".PNG"];
    FIRStorageReference *islandRef = [storageRef child:downURL];
    
    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
        if (error != nil) {
            // Uh-oh, an error occurred!
        } else {
            // Data for "images/island.jpg" is returned
            UIImage *islandImage = [UIImage imageWithData:data];
            [_imagePost setImage:islandImage];
        }
    }];
    }
    if(_profilePreIm != nil)
        [_imageProfile setImage:_profilePreIm];
    else{
    downURL = [selectedID stringByAppendingString: @"/profileImage.PNG"];
    FIRStorageReference * islandRef = [storageRef child:downURL];
    
    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
        if (error != nil) {
            // Uh-oh, an error occurred!
        } else {
            // Data for "images/island.jpg" is returned
            UIImage *islandImage = [UIImage imageWithData:data];
            [_imageProfile setImage:islandImage];
        }
    }];
    }
    
    [_textContent setText: selectedComment];
    [_textPost setText: selectedTitle];
    

    if([selectedCategory[0] isEqualToNumber:[NSNumber numberWithInteger:1]]==0)
        [_buttonMW setBackgroundImage:[UIImage imageNamed:@"PostButtonCateDisable.png"] forState:UIControlStateNormal];
    if([selectedCategory[1] isEqualToNumber:[NSNumber numberWithInteger:1]]==0)
        [_buttonWM setBackgroundImage:[UIImage imageNamed:@"PostButtonCateDisable.png"] forState:UIControlStateNormal];
    if([selectedCategory[2] isEqualToNumber:[NSNumber numberWithInteger:1]]==0)
        [_buttonTM setBackgroundImage:[UIImage imageNamed:@"PostButtonCateDisable.png"] forState:UIControlStateNormal];
    if([selectedCategory[3] isEqualToNumber:[NSNumber numberWithInteger:1]]==0)
        [_buttonMM setBackgroundImage:[UIImage imageNamed:@"PostButtonCateDisable.png"] forState:UIControlStateNormal];
    if([selectedCategory[4] isEqualToNumber:[NSNumber numberWithInteger:1]]==0)
        [_buttonWW setBackgroundImage:[UIImage imageNamed:@"PostButtonCateDisable.png"] forState:UIControlStateNormal];
    if([selectedCategory[5] isEqualToNumber:[NSNumber numberWithInteger:1]]==0)
        [_buttonFB setBackgroundImage:[UIImage imageNamed:@"PostButtonCateDisable.png"] forState:UIControlStateNormal];
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



- (IBAction)onBack:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];

}

- (IBAction)onReportPost:(id)sender {
    
    ReportPostViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"reportpost"];
    apvc.selID = selectedID;
    apvc.selName = _textName.text;
    apvc.selLocation = _textLocation.text;
    apvc.pr1 = _imagePost.image;
    apvc.pr2 = _imageProfile.image;
    [self.navigationController pushViewController:apvc animated:YES];
}
- (IBAction)onMessage:(id)sender {
    ChatUIViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chatUI"];
    NSString *messageID = [[FIRAuth auth].currentUser.uid stringByAppendingString:selectedID];
    apvc.messageID = messageID;
    apvc.nameOfSender = _textName.text;
    [self.navigationController pushViewController:apvc animated:YES];
    
}
@end
