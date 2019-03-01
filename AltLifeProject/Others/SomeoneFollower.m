//
//  SomeoneFollower.m
//  AltLife
//
//  Created by BradReed on 10/15/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "SomeoneFollower.h"
#import "PeopleViewCell.h"
#import "CViewFlowLayout.h"
#import "UserAccountViewController.h"
extern NSArray *interestingList;
extern NSString *selectedPeopleID;
extern NSDictionary *selectedPeopleArray;

@interface SomeoneFollower (){
    NSArray *arrayIDs;
    NSMutableArray *arrayPeople;
    NSMutableDictionary *dict;
}

@end
extern NSString *nameMyProfile;
@implementation SomeoneFollower

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayPeople = [[NSMutableArray alloc] init];
    dict = [[NSMutableDictionary alloc]init];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    CGRect viewRect = self.view.bounds;
    
    [_collectionView setFrame:CGRectMake(5, 80, viewRect.size.width-10, viewRect.size.height-80)];
    [_collectionView registerNib:[UINib nibWithNibName:@"PeopleViewCell" bundle:nil] forCellWithReuseIdentifier:@"PeopleViewCell"];
    
    CViewFlowLayout *f1 = [[CViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = f1;
    [self.collectionView reloadData];
    
    _collectionView.layer.masksToBounds = YES;
    _collectionView.layer.cornerRadius = 6;
    
    self.ref = [[FIRDatabase database] reference];   // Set Firebase Dababase handle.
    
    // Do any additional setup after loading the view.
    if(_isMe == 1)
    {
        NSString *fText;
        if(_isFollower == 0)
        {
            fText = @"'s Following";
            [[[_ref child:@"users"]  child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *postDict = snapshot.value;
                arrayIDs = [postDict objectForKey:@"followingPeople"];
                [self refreshCollectionView];
                
            }];
        }
        else if(_isFollower == 1)
        {
             fText = @"'s Follower";
            [[[_ref child:@"users"]  child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *postDict = snapshot.value;
                arrayIDs = [postDict objectForKey:@"followerPeople"];
                [self refreshCollectionView];
            }];
        }
        NSString *temp = [nameMyProfile stringByAppendingString:fText];
       [_titleText setText:temp];
        
    }
    else{
        [[[_ref child:@"users"]  child:self.followID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *postDict = snapshot.value;
            NSString *nameOfMe = [postDict objectForKey:@"name"];
            
            NSString *fText;
            if(_isFollower == 0)
            {
                fText = @"'s Following";
                [[[_ref child:@"users"]  child:self.followID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSDictionary *postDict = snapshot.value;
                    arrayIDs = [postDict objectForKey:@"followingPeople"];
                    [self refreshCollectionView];
                }];
            }
            else if(_isFollower == 1)
            {
                fText = @"'s Follower";
                [[[_ref child:@"users"]  child:self.followID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSDictionary *postDict = snapshot.value;
                    arrayIDs = [postDict objectForKey:@"followerPeople"];
                    [self refreshCollectionView];
                }];
            }
            NSString *temp = [nameOfMe stringByAppendingString:fText];
            [_titleText setText:temp];
            
        }];
    }
    
}

-(void) refreshCollectionView{
    [[_ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDic = snapshot.value;
        for(id item in arrayIDs)
        {
            NSDictionary *eachUsers =[postDic objectForKey:item];
            [arrayPeople addObject:eachUsers];
            FIRStorage *storage = [FIRStorage storage];
            FIRStorageReference *storageRef = [storage reference];
            NSString *downURL = [item stringByAppendingString: @"/profileImage.PNG"];
            FIRStorageReference *islandRef = [storageRef child:downURL];
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    
                    UIImage *islandImage = [UIImage imageWithData:data];
                    NSLog(@"%@,%@",islandRef.fullPath, islandRef.name);
                    NSString *keyOfImage = [islandRef.fullPath substringToIndex:[islandRef.fullPath length]-17];
                    if(islandImage == NULL)
                        [dict setObject:[UIImage imageNamed:@"Account@3.PNG"] forKey:keyOfImage];
                    else
                        [dict setObject:islandImage forKey:keyOfImage];
                    [_collectionView reloadData];
                }
            }];
        }
     [_collectionView reloadData];
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


-(NSInteger) collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrayPeople.count;
}
-(__kindof UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    static NSString *cellIdentifier = @"PeopleViewCell";
    PeopleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    
    NSDictionary *user = [arrayPeople objectAtIndex:indexPath.row];
    [cell.stringName setText:[user objectForKey:@"name"]];
    [cell.stringText setText:[user objectForKey:@"explain"]];
    [cell.stringAddress setText:[user objectForKey:@"location"]];
    
    if([dict objectForKey:arrayIDs[indexPath.row]]!=nil)
    {
        [cell.imageView setImage:[dict objectForKey:arrayIDs[indexPath.row]]];
        [cell.imageAvatar setImage:[dict objectForKey:arrayIDs
                                    [indexPath.row]]];
    }
    else{
        cell.imageView.image = nil;
        cell.imageAvatar.image = nil;
        //[cell.imageView setImage:[UIImage imageNamed:@"background_home.png"]];
        //[cell.imageAvatar setImage:[dict objectForKey:arrayKeys[indexPath.row]]];
        
    }
    
    //[cell.textString setText:@"aaaa"];
    //cell.backgroundColor = [UIColor blueColor];
    return cell;
}

- (CGSize) collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth/2-10;
    
    float cellHeight = 300;
    if(indexPath.row%2 == 0)
        cellHeight = 300;
    else
        cellHeight = 350;
    CGSize size = CGSizeMake(cellWidth, cellHeight);
    return size;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    selectedPeopleID = arrayIDs[indexPath.row];
    selectedPeopleArray  = arrayPeople[indexPath.row];
    UserAccountViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAccountViewController"];
    [self.navigationController pushViewController:apvc animated:YES];
    
}

@end

