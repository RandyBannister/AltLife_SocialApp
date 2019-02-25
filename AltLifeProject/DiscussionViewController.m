//
//  DiscussionViewController.m
//  AltLife
//
//  Created by BradReed on 10/5/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "DiscussionViewController.h"
#import "DisTableViewCell.h"
#import "AddDiscussionViewController.h"
#import "AddCommentViewController.h"

@interface DiscussionViewController ()
{
    NSDictionary *arrayOfDiscussions;
    NSMutableArray *arrayOfPeople;
    NSMutableDictionary *arrayOfImages;
}
@end
int dd = 0;
int countOfD = 0;
@implementation DiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    countOfD = 0;
    dd = 0;
    arrayOfPeople = [[NSMutableArray alloc] init];
    arrayOfImages = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view.
    CGRect viewRect = self.view.bounds;
    self.tableView.separatorColor = [UIColor clearColor];
    [_tableView setFrame:CGRectMake(0, 0, viewRect.size.width-10, viewRect.size.height)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_tableView registerNib:[UINib nibWithNibName:@"DisTableViewCell" bundle:nil] forCellReuseIdentifier:@"DisTableViewCell"];
    self.ref = [[FIRDatabase database] reference];
    [[_ref child:@"Discussion"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        if(postDict == [NSNull null])
            return;
        arrayOfDiscussions = [postDict copy];
        
        for(int i=0;i<arrayOfDiscussions.count; i++)
        {
            
            NSString *key =[arrayOfDiscussions.allKeys objectAtIndex:i];
            key = [key substringToIndex:28];
        
            [[[_ref child:@"users"]  child:key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                countOfD ++;
                [arrayOfPeople addObject:snapshot.value];
                if(countOfD == arrayOfDiscussions.count)
                    [_tableView reloadData];
                
                FIRStorage *storage = [FIRStorage storage];
                FIRStorageReference *storageRef = [storage reference];
                NSString *downURL = [key stringByAppendingString: @"/profileImage.PNG"];
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
                        keyOfImage = [keyOfImage stringByAppendingString:[NSString stringWithFormat:@"%d", dd]];
                        dd ++ ;
                        if(islandImage == NULL)
                            [arrayOfImages setObject:[UIImage imageNamed:@"Account@3.PNG"] forKey:keyOfImage];
                        else
                            [arrayOfImages setObject:islandImage forKey:keyOfImage];
                        [_tableView reloadData];
                    }
                }];
            }];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfPeople.count;
}
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *tableViewCellName = @"DisTableViewCell";
    DisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellName];
    if(cell == nil)
    {
        cell = [[DisTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellName];
    }
    NSString *title = [[arrayOfDiscussions objectForKey:[arrayOfDiscussions.allKeys objectAtIndex:indexPath.row]] objectForKey:@"title"];
    [cell.textTitle setText: title];
    NSString *content = [[arrayOfDiscussions objectForKey:[arrayOfDiscussions.allKeys objectAtIndex:indexPath.row]] objectForKey:@"contents"];
    [cell.textDis setText: content];
    int countOfcomments = [[[arrayOfDiscussions objectForKey:[arrayOfDiscussions.allKeys objectAtIndex:indexPath.row]] objectForKey:@"comments"] count];
    NSString *countString = [NSString stringWithFormat:@"Comment (%d)", countOfcomments];
    [cell.countOfComments setText: countString];
    
    NSDictionary *temp = [arrayOfPeople objectAtIndex:indexPath.row];
    [cell.textName  setText:[temp objectForKey:@"name"]];
    
    if(arrayOfImages.allKeys.count > indexPath.row)
    {
        [cell.profileImage setImage:[arrayOfImages objectForKey:arrayOfImages.allKeys[indexPath.row]]];
    }
    else{
        cell.profileImage.image = nil;
        //[cell.imageView setImage:[UIImage imageNamed:@"background_home.png"]];
        //[cell.imageAvatar setImage:[dict objectForKey:arrayKeys[indexPath.row]]];
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
- (IBAction)onAddDis:(id)sender {
    AddDiscussionViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDis"];
    [self.navigationController pushViewController:apvc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddCommentViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCom"];
    
    if(arrayOfImages.allKeys.count > indexPath.row)
        apvc.profileI = [arrayOfImages objectForKey: arrayOfImages.allKeys[indexPath.row]];

    apvc.profileC = [[arrayOfDiscussions objectForKey:[arrayOfDiscussions.allKeys objectAtIndex:indexPath.row]] objectForKey:@"contents"];
     apvc.profileT = [[arrayOfDiscussions objectForKey:[arrayOfDiscussions.allKeys objectAtIndex:indexPath.row]] objectForKey:@"title"];
    
    NSString *ago = arrayOfDiscussions.allKeys[indexPath.row];
    ago = [ago substringFromIndex:28];
    apvc.profileA = ago;
    
    NSDictionary *temp = [arrayOfPeople objectAtIndex:indexPath.row];
    apvc.profileN = [temp objectForKey:@"name"];

    apvc.profileIDofDiscussion = arrayOfDiscussions.allKeys[indexPath.row];
    [self.navigationController pushViewController:apvc animated:YES];
}

@end
