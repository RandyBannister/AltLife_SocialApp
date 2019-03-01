//
//  UserAccountViewController.m
//  AltLife
//
//  Created by BradReed on 10/15/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "UserAccountViewController.h"
#import "SomeoneFollower.h"
#import "ReportUserController.h"
#import "ChatUIViewController.h"

@interface UserAccountViewController (){
    NSArray *interestingArray;
}

@end

NSMutableArray *arrayTemp;
extern NSString *selectedPeopleID;
extern NSDictionary *selectedPeopleArray;
int ifFollowed = -1;
FIRDatabaseHandle handle, handle1;

@implementation UserAccountViewController

-(NSString*)numberWithShortcut:(NSNumber*)number
{
    unsigned long long value = [number longLongValue];
    
    NSUInteger index = 0;
    double dvalue = (double)value;
    
    NSArray *suffix = @[ @"", @"K", @"M", @"B", @"T", @"P", @"E" ];
    
    while ((value /= 1000) && ++index) dvalue /= 1000;
    
    NSString *svalue = [NSString stringWithFormat:@"%@%@",[NSNumber numberWithInt:dvalue], [suffix objectAtIndex:index]];
    
    return svalue;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    arrayTemp = [[NSMutableArray alloc]init];
    self.ref = [[FIRDatabase database] reference];   // Set Firebase Dababase handle.
    
    // Do any additional setup after loading the view.
    _userProfileImage.layer.masksToBounds = YES;
    _userProfileImage.layer.cornerRadius = _userProfileImage.frame.size.width/2;
    [_userProfileImage.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [_userProfileImage.layer setBorderWidth:7.0];
    [_userName setText:[selectedPeopleArray objectForKey:@"name"]];
    [_userLocation setText:[selectedPeopleArray objectForKey:@"location"]];
    [_explainText setText:[selectedPeopleArray objectForKey:@"explain"]];
    interestingArray = [selectedPeopleArray objectForKey:@"interesting"];
    if([interestingArray[0] intValue] == 1)
       [ _caBtn setImage:[UIImage imageNamed :@"checkedinter.png"] forState:UIControlStateNormal];
    if([interestingArray[1] intValue] == 1)
        [ _hookupBtn setImage:[UIImage imageNamed :@"checkedinter.png"] forState:UIControlStateNormal];

    if([interestingArray[2] intValue] == 1)
        [ _bdsmBtn setImage:[UIImage imageNamed :@"checkedinter.png"] forState:UIControlStateNormal];
    if([interestingArray[3] intValue] == 1)
        [ _topBtn setImage:[UIImage imageNamed :@"checkedinter.png"] forState:UIControlStateNormal];
    if([interestingArray[4] intValue] == 1)
        [ _bottomBtn setImage:[UIImage imageNamed :@"checkedinter.png"] forState:UIControlStateNormal];
    if([interestingArray[5] intValue] == 1)
        [ _chatBtn setImage:[UIImage imageNamed :@"checkedinter.png"] forState:UIControlStateNormal];
    if([interestingArray[6] intValue] == 1)
        [ _friendBtn setImage:[UIImage imageNamed :@"checkedinter.png"] forState:UIControlStateNormal];
    if([interestingArray[7] intValue] == 1)
        [ _swingbtn setImage:[UIImage imageNamed :@"checkedinter.png"] forState:UIControlStateNormal];
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    
    NSString *downURL = [selectedPeopleID stringByAppendingString: @"/profileImage.PNG"];
    FIRStorageReference *islandRef = [storageRef child:downURL];
    
    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
        if (error != nil) {
            // Uh-oh, an error occurred!
        } else {
            // Data for "images/island.jpg" is returned
            UIImage *islandImage = [UIImage imageWithData:data];
            [_userProfileImage setImage:islandImage];
            
        }
    }];
    
    [[[_ref child:@"users"]  child:selectedPeopleID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray * addArray = [[NSMutableArray alloc]init];
        NSDictionary *postDict = snapshot.value;
        NSLog(@"%@",postDict);
        
        addArray = [postDict objectForKey:@"followingPeople"];
        
        
        
        if(addArray == nil)
            [_countOfFollowing setText:@"0"];
        else
        {
            [_countOfFollowing setText:[self numberWithShortcut:[NSNumber numberWithInt:addArray.count]]];
            
        }
        
        addArray = [postDict objectForKey:@"followerPeople"];
       
        
        if(addArray == nil)
            [_countOfFollower setText:@"0"];
        else
        {
            [_countOfFollower setText:[self numberWithShortcut:[NSNumber numberWithInt:addArray.count]]];
            
        }
    }];
    
    [[[_ref child:@"users"]  child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray * addArray = [[NSMutableArray alloc]init];
        NSDictionary *postDict = snapshot.value;
        NSLog(@"%@",postDict);
        addArray = [postDict objectForKey:@"followingPeople"];
        if(addArray == nil)
            addArray = [[NSMutableArray alloc]init];
        
        for(id item in addArray)
            if([item isEqual:selectedPeopleID])
            {
                ifFollowed = 1;
                [_followButton setImage:[UIImage imageNamed:@"followedBtn.png"] forState:UIControlStateNormal];
                break;
            }
        
    }];
    

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


- (IBAction)onCA:(id)sender {

}

- (IBAction)onHook:(id)sender {
}

- (IBAction)onTop:(id)sender {
}

- (IBAction)onBD:(id)sender {
}

- (IBAction)onBottom:(id)sender {
}

- (IBAction)onChat:(id)sender {
}

- (IBAction)onFri:(id)sender {
}

- (IBAction)onSw:(id)sender {
}

- (IBAction)onBack:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];

}

- (IBAction)onReport:(id)sender {
    
    ReportUserController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"reportuser"];
    apvc.selID  = selectedPeopleID;
    apvc.name = _userName.text;
    apvc.location = _userLocation.text;
    apvc.profileimg = _userProfileImage.image;
    [self.navigationController pushViewController:apvc animated:YES];
}

- (IBAction)onFollowing:(id)sender {
    SomeoneFollower* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"someonefollower"];
    apvc.followID = selectedPeopleID;
    apvc.isFollower = 0;
    apvc.isMe = 0;
    [self.navigationController pushViewController:apvc animated:YES];

}
- (IBAction)onFollowers:(id)sender {
    SomeoneFollower* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"someonefollower"];
    apvc.followID = selectedPeopleID;
    apvc.isFollower = 1;
    apvc.isMe = 0;
    [self.navigationController pushViewController:apvc animated:YES];

}



- (IBAction)onFollow:(id)sender {
    if(ifFollowed == 1)
    {
        [_followButton setImage:[UIImage imageNamed:@"FollowBtn.png"] forState:UIControlStateNormal];
        [[[_ref child:@"users"]  child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSMutableArray * addArray = [[NSMutableArray alloc]init];
            NSDictionary *postDict = snapshot.value;
            NSLog(@"%@",postDict);
            addArray = [postDict objectForKey:@"followingPeople"];
            if(addArray == nil)
                addArray = [[NSMutableArray alloc]init];
            
            for(id item in addArray)
                if([item isEqual:selectedPeopleID]){
                    [addArray removeObject:item];
                    break;
                }
            
            arrayTemp = [addArray copy];
            [[[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid] child:@"followingPeople"]
             setValue:arrayTemp];
            
        }];
        
        [[[_ref child:@"users"]  child:selectedPeopleID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSMutableArray * addArray = [[NSMutableArray alloc]init];
            NSDictionary *postDict = snapshot.value;
            NSLog(@"%@",postDict);
            addArray = [postDict objectForKey:@"followerPeople"];
            if(addArray == nil)
                addArray = [[NSMutableArray alloc]init];
            
            for(id item in addArray)
                if([item isEqual:[FIRAuth auth].currentUser.uid]){
                    [addArray removeObject:item];
                    break;
                }
            [[[[_ref child:@"users"] child:selectedPeopleID] child:@"followerPeople"]
             setValue:addArray];
            
            
        }];
    }
    else if(ifFollowed == -1)
    {
        
        [_followButton setImage:[UIImage imageNamed:@"followedBtn.png"] forState:UIControlStateNormal];
        [[[_ref child:@"users"]  child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSMutableArray * addArray = [[NSMutableArray alloc]init];
            NSDictionary *postDict = snapshot.value;
            NSLog(@"%@",postDict);
            addArray = [postDict objectForKey:@"followingPeople"];
            if(addArray == nil)
                addArray = [[NSMutableArray alloc]init];
            [addArray addObject:selectedPeopleID];
            arrayTemp = [addArray copy];
            [[[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid] child:@"followingPeople"]
             setValue:arrayTemp];
            
        }];
        
         [[[_ref child:@"users"]  child:selectedPeopleID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSMutableArray * addArray = [[NSMutableArray alloc]init];
            NSDictionary *postDict = snapshot.value;
            NSLog(@"%@",postDict);
            addArray = [postDict objectForKey:@"followerPeople"];
            if(addArray == nil)
                addArray = [[NSMutableArray alloc]init];
            [addArray addObject:[FIRAuth auth].currentUser.uid];
            [[[[_ref child:@"users"] child:selectedPeopleID] child:@"followerPeople"]
                 setValue:addArray];
            
            
         }];
        
    }
    ifFollowed *= -1;
}
- (IBAction)onMessage:(id)sender {
    ChatUIViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chatUI"];
    NSString *messageID = [[FIRAuth auth].currentUser.uid stringByAppendingString:selectedPeopleID];
    apvc.messageID = messageID;
    apvc.nameOfSender = _userName.text;
    [self.navigationController pushViewController:apvc animated:YES];
    
}
@end
