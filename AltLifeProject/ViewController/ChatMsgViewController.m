//
//  ChatMsgViewController.m
//  AltLifeProject
//
//  Created by Mobile Star on 11/1/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "ChatMsgViewController.h"
#import "MessageTableCell.h"
#import "ChatUIViewController.h"

@interface ChatMsgViewController (){
    NSMutableArray *arrayOfChats;
    NSMutableArray *arrayOfNames;
    NSMutableDictionary *arrayOfImages;
    NSMutableArray *channelsArray;
    NSMutableArray *arrayofCCC;
    NSArray *sortedKeys;
    NSMutableArray *dateArrays;
}

@end

@implementation ChatMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.ref = [[FIRDatabase database] reference];   // Set Firebase Dababase handle.
    
    [_tableView registerNib:[UINib nibWithNibName:@"MessageTableCell" bundle:nil] forCellReuseIdentifier:@"MessageTableCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    

}

-(void) viewWillAppear:(BOOL)animated{
    channelsArray  = [[NSMutableArray alloc] init];
    dateArrays = [[NSMutableArray alloc]init];
    arrayOfChats = [[NSMutableArray alloc] init];
    arrayOfImages = [[NSMutableDictionary alloc] init];
    arrayOfNames = [[NSMutableArray alloc] init];
    arrayofCCC = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.

    
    [[_ref child:@"Messages"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        if(postDict == [NSNull null])
            return;
        for(int i=0;i<postDict.count;i++)
        {
            
            NSString * Channels = postDict.allKeys[i];
            NSString *ID1 = [Channels substringToIndex:28];
            NSString *ID2 = [Channels substringFromIndex:28];
            NSString *CurrentID = [FIRAuth auth].currentUser.uid;

            if([ID1 isEqualToString:CurrentID])
            {
                [arrayOfChats addObject:ID2];
                [channelsArray addObject:Channels];
                NSDictionary *temp = [postDict objectForKey:postDict.allKeys[i]];
                sortedKeys = [[temp allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
                [arrayofCCC addObject:[temp objectForKey: sortedKeys[sortedKeys.count-1]]];
                NSString *dateOfChat = sortedKeys[sortedKeys.count-1];
                dateOfChat = [dateOfChat substringToIndex:14];
                [dateArrays addObject:dateOfChat];
                NSLog(@"arrayOfCCC %d   ",i);

            }
            else if([ID2 isEqualToString:CurrentID])
            {
                [arrayOfChats addObject:ID1];
                [channelsArray addObject:Channels];
                NSDictionary *temp = [postDict objectForKey:postDict.allKeys[i]];
                sortedKeys = [[temp allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
                [arrayofCCC addObject:[temp objectForKey: sortedKeys[sortedKeys.count-1]]];
                NSString *dateOfChat = sortedKeys[sortedKeys.count-1];
                dateOfChat = [dateOfChat substringToIndex:14];
                [dateArrays addObject:dateOfChat];

                NSLog(@"arrayOfCCC %d   ",i);

            }
            
        }
        [self refreshPeople];
        
    }];
}

-(void) refreshPeople{
    [[_ref child:@"users"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        if(postDict == [NSNull null] && arrayOfChats.count == 0)
            return;
        for(int i=0;i<arrayOfChats.count;i++)
        {
            for(int j=0;j<postDict.count;j++)
            {
                if([arrayOfChats[i] isEqualToString:postDict.allKeys[j]])
                {
                    [arrayOfNames addObject:[[postDict objectForKey:postDict.allKeys[j]] objectForKey:@"name"]];
                    NSLog(@"arrayOfNames %d   ",i);
                    break;
                }
            }
        }
        [_tableView reloadData];
    }];
    if(arrayOfChats.count!=0)
    for(int i=0;i<arrayOfChats.count;i++)
    {
        FIRStorage *storage = [FIRStorage storage];
        FIRStorageReference *storageRef = [storage reference];
        NSString *downURL = [arrayOfChats[i] stringByAppendingString: @"/profileImage.PNG"];
        FIRStorageReference *islandRef = [storageRef child:downURL];
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                UIImage *islandImage = [UIImage imageWithData:data];
                NSLog(@"%@,%@",islandRef.fullPath, islandRef.name);
                NSString *keyOfImage = [islandRef.fullPath substringToIndex:[islandRef.fullPath     length]-17];
                if(islandImage == NULL)
                    [arrayOfImages setObject:[UIImage imageNamed:@"Account@3.PNG"] forKey:keyOfImage];
                else
                    [arrayOfImages setObject:islandImage forKey:keyOfImage];
                [_tableView reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfChats.count;
}
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *tableViewCellName = @"MessageTableCell";
    MessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellName];
    if(cell == nil)
    {
        cell = [[MessageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellName];
    }
    if(arrayofCCC.count!=0)
        [cell.nameText setText:[arrayOfNames objectAtIndex:indexPath.row]];
    if(arrayOfImages.count!=0)
        [cell.profileImage setImage:[arrayOfImages objectForKey:[arrayOfChats objectAtIndex:indexPath.row]]];
    if(arrayOfChats.count !=0)
        [cell.chatText setText:[arrayofCCC objectAtIndex:indexPath.row]];
    if(dateArrays.count !=0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyyMMddHHmmss";
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-07:00"]];
        
        NSDate *date = [dateFormatter dateFromString:dateArrays[indexPath.row]];
        
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
        [cell.agoText setText:agoString];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 //   clickedCategory = indexPath.row;
    ChatUIViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chatUI"];
    apvc.messageID = channelsArray[indexPath.row];
    apvc.nameOfSender = arrayOfNames[indexPath.row];
    MessageTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    apvc.senderImage = cell.profileImage.image;//[arrayOfImages objectForKey:arrayOfChats[indexPath.row]];
    [self.navigationController pushViewController:apvc animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
