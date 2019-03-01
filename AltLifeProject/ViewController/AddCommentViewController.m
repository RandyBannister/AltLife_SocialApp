//
//  AddCommentViewController.m
//  AltLifeProject
//
//  Created by Mobile Star on 11/2/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "AddCommentViewController.h"
#import "AddCommentTableViewCell.h"

@interface AddCommentViewController (){
    
    NSMutableDictionary *arrayOfComments;
    NSMutableDictionary *arrayOfphotos;
    
    NSArray *sortedKeys1;
    NSMutableDictionary *arrayOfNames;
}

@end

@implementation AddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_profileImage setImage:_profileI];
    arrayOfphotos = [[NSMutableDictionary alloc]init];
    arrayOfComments = [[NSMutableDictionary alloc] init];
    arrayOfNames = [[NSMutableDictionary alloc]init];
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    [_profileName setText:_profileN];
    [_titleText setText:_profileT];
    [_contentsText setText:_profileC];
   // [_contentsText sizeToFit];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 300;
    
    _postComment.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
   // [self.tableView setNeedsLayout];
   // [self.tableView layoutIfNeeded];
    self.ref = [[FIRDatabase database] reference];   // Set Firebase Dababase handle.
    
    [self refresh];
    [_tableView registerNib:[UINib nibWithNibName:@"AddCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableCell"];
    

    
    // Do any additional setup after loading the view.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [_postComment resignFirstResponder];
    return YES;
}
-(void) refreshPhoto{
    if(arrayOfComments == [NSNull null])
        return;
    for(int i=0;i<arrayOfComments.count;i++)
    {
        NSString *temp = arrayOfComments.allKeys[i];
        temp = [temp substringFromIndex:14];
        [[[_ref child:@"users"] child:temp] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *postDict = snapshot.value;
            
            [arrayOfNames setObject:[postDict objectForKey:@"name"] forKey:temp];
            [_tableView reloadData];

        }
         ];
            FIRStorage *storage = [FIRStorage storage];
            FIRStorageReference *storageRef = [storage reference];
            NSString *downURL = [temp stringByAppendingString: @"/profileImage.PNG"];
            FIRStorageReference *islandRef = [storageRef child:downURL];
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    UIImage *islandImage = [UIImage imageWithData:data];
                    NSLog(@"%@,%@",islandRef.fullPath, islandRef.name);
                    NSString *keyOfImage = [islandRef.fullPath substringToIndex:[islandRef.fullPath length]-17];
                    if(islandImage == NULL)
                        [arrayOfphotos setObject:[UIImage imageNamed:@"Account@3.PNG"] forKey:keyOfImage];
                    else
                        [arrayOfphotos setObject:islandImage forKey:keyOfImage];
                    [_tableView reloadData];
                    }
            }];
    }
}

-(void) refresh{
    [[[[_ref child:@"Discussion"] child:_profileIDofDiscussion] child:@"comments"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        
        if(postDict != [NSNull null]){
          sortedKeys1 = [[postDict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
            
            
        for(int i=sortedKeys1.count-1;i>=0;i--)
            [arrayOfComments setObject:[postDict objectForKey:sortedKeys1[i]] forKey:sortedKeys1[i]];
        
        //arrayOfComments = [postDict copy];
        }
      
        
        
        NSString *commentString;
        if(postDict != [NSNull null])
             commentString = [NSString stringWithFormat:@"Comment (%lu)", (unsigned long)postDict.count];
        else
            commentString = [NSString stringWithFormat:@"Comment (0)"];
        [_countOfCommentsText setText:commentString];
        [self refreshPhoto];
        [_tableView reloadData];
        
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

- (IBAction)onBack:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];

}
- (IBAction)onSend:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-07:00"]];
    NSDate * timeNow = [NSDate date];
    
    NSString *stringTime = [dateFormatter stringFromDate:timeNow];
    NSString *addID = [stringTime stringByAppendingString:[FIRAuth auth].currentUser.uid];
    [[[[[[_ref child:@"Discussion"] child:_profileIDofDiscussion] child:@"comments"] child:addID] child:@"contents"]
     setValue:_postComment.text];
    [_postComment setText:@""];
    [self refresh];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(arrayOfComments == [NSNull null])
        return 0;
    return arrayOfComments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableCell" forIndexPath:indexPath];
    NSDictionary * temp = [arrayOfComments objectForKey:sortedKeys1[indexPath.row]];
    NSString *stringTemp = sortedKeys1[indexPath.row];
    stringTemp = [stringTemp substringFromIndex:14];
    [cell.profileName setText:[arrayOfNames objectForKey:stringTemp]];
    [cell.contentsText setText:[temp objectForKey:@"contents"]];
    [cell.profileImage setImage:[arrayOfphotos objectForKey:stringTemp]];

    
    return cell;
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
