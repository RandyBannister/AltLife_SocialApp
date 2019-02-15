//
//  FeedViewController.m
//  AltLife
//
//  Created by BradReed on 10/5/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "FeedViewController.h"
#import "CollectionViewCell.h"
#import <Foundation/Foundation.h>
#import "PostViewController.h"
@import FirebaseAuth;

@interface userMember :NSObject
@property (nonatomic, strong) NSString *uID;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Comment;
@property (nonatomic, strong) NSString *dateID;
@property (nonatomic, strong) NSArray *categoryPost;

@end

@implementation userMember : NSObject
@end

extern NSString *selectedID, *selectedTitle, *selectedComment, *selectedDate;
extern UIImage *selectedProfileImage, *selectedPostImage;
extern NSArray *selectedCategory;
extern NSString *enteredLocation;


@interface FeedViewController (){
    UIRefreshControl *refreshControl;
    NSMutableArray *arrayPosts;
    NSMutableDictionary *arrayAccounts;
    NSMutableArray *userMembersArray;
    NSMutableDictionary *imagePosts;
    NSMutableDictionary *imageProfiles;
    
    NSArray *myFollowingArray;
 
}
@end


@implementation FeedViewController

-(BOOL) checkFollow:(NSArray *)array1 forCheck:(NSString *)checkID{
    for(id item in array1)
        if([item isEqual:checkID])
            return YES;
    return NO;
}

- (void)viewDidLoad {
    imageProfiles = [[NSMutableDictionary alloc]init];
    imagePosts = [[NSMutableDictionary alloc]init];
    userMembersArray = [[NSMutableArray alloc] init];
    arrayPosts = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                                          green:240.0f/255.0f
                                                           blue:245.0f/255.0f
                                                          alpha:1.0f];
    
    self.ref = [[FIRDatabase database] reference];
    
    [[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDic = snapshot.value;
        myFollowingArray = [postDic objectForKey:@"followingPeople"];
    }];
    

    CGRect viewRect = self.view.bounds;
    [_collectionView setFrame:CGRectMake(0, 0, viewRect.size.width-10, viewRect.size.height-185)];
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    CViewFlowLayout *f1 = [[CViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = f1;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    
    
    
    [userMembersArray removeAllObjects];
    [imagePosts removeAllObjects];
    [imageProfiles removeAllObjects];
    [self.collectionView reloadData];
    [[_ref child:@"Posts"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        // ...
        if(postDict == [NSNull null])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No posts"                                                                       message:@"There are no posts match on your profile." preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                
            }];
            [alert addAction:actAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            for(int i=0;i<postDict.count;i++)
            {
                NSDictionary * dict1 = [postDict objectForKey:postDict.allKeys[i]];
                NSLog(@"%@", dict1);
                if(![self checkFollow:myFollowingArray forCheck:postDict.allKeys[i]] && ![postDict.allKeys[i] isEqual:[FIRAuth auth].currentUser.uid])
                {
                    continue;
                }
                for(int j=0;j<dict1.allKeys.count;j++)
                {
                    
                    userMember *a = [userMember alloc];
                    a.uID = [postDict.allKeys objectAtIndex:i];
                    
                    NSArray *cat =[[dict1 objectForKey:dict1.allKeys[j]] objectForKey:@"Category"];
                    a.categoryPost = cat;
                    
                    
                    NSString *tit =[[dict1 objectForKey:dict1.allKeys[j]] objectForKey:@"Title"];
                    a.Title = tit;
                    NSString *com =[[dict1 objectForKey:dict1.allKeys[j]] objectForKey:@"Comment"];
                    a.Comment = com;
                    NSString *dat =dict1.allKeys[j];
                    a.dateID = dat;
                    [userMembersArray addObject:a];
                    //       [self.collectionView reloadData];
                    
                    FIRStorage *storage = [FIRStorage storage];
                    FIRStorageReference *storageRef = [storage reference];
                    
                    NSString *downURL = [a.uID stringByAppendingString: @"/"];
                    downURL = [downURL stringByAppendingString: a.dateID];
                    downURL = [downURL stringByAppendingString: @".PNG"];
                    FIRStorageReference *islandRef = [storageRef child:downURL];
                    
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                        if (error != nil) {
                            // Uh-oh, an error occurred!
                        } else {
                            // Data for "images/island.jpg" is returned
                            UIImage *islandImage = [UIImage imageWithData:data];
                            NSString *key = [islandRef.fullPath substringToIndex:[islandRef.fullPath length]-4];
                            [imagePosts setValue:islandImage forKeyPath:key];
                            [self.collectionView reloadData];
                            
                        }
                    }];
                    
                    
                    downURL = [a.uID stringByAppendingString: @"/profileImage.PNG"];
                    islandRef = [storageRef child:downURL];
                    
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                        if (error != nil) {
                            // Uh-oh, an error occurred!
                        } else {
                            // Data for "images/island.jpg" is returned
                            UIImage *islandImage = [UIImage imageWithData:data];
                            NSString *key = [islandRef.fullPath substringToIndex:[islandRef.fullPath length]-17];
                            [imageProfiles setValue:islandImage forKeyPath:key];
                            [self.collectionView reloadData];
                            
                        }
                    }];
                }
            }
            [self.collectionView reloadData];
            
        }
        
        NSLog(@"Success!");
        
    }];
    
    [[_ref child:@"users"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        arrayAccounts = snapshot.value;
        // ...
        //      [self.collectionView reloadData];
        
        NSLog(@"Success!");
        
    }];
    
    
    
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    
    
}


-(void) startRefresh{
    [userMembersArray removeAllObjects];
    [imagePosts removeAllObjects];
    [imageProfiles removeAllObjects];
    [self.collectionView reloadData];
    
    
    [[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
    NSDictionary *postDic = snapshot.value;
    myFollowingArray = [postDic objectForKey:@"followingPeople"];
    
        [[_ref child:@"Posts"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *postDict = snapshot.value;
            // ...
            if(postDict == [NSNull null])
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No posts"                                                                       message:@"There are no posts match on your profile." preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    
                }];
                [alert addAction:actAlert];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else{
                for(int i=0;i<postDict.count;i++)
                {
                    NSDictionary * dict1 = [postDict objectForKey:postDict.allKeys[i]];
                    NSLog(@"%@", dict1);
                    if(![self checkFollow:myFollowingArray forCheck:postDict.allKeys[i]] && ![postDict.allKeys[i] isEqual:[FIRAuth auth].currentUser.uid])
                    {
                        continue;
                    }
                    for(int j=0;j<dict1.allKeys.count;j++)
                    {
                        
                        userMember *a = [userMember alloc];
                        a.uID = [postDict.allKeys objectAtIndex:i];
                        
                        NSArray *cat =[[dict1 objectForKey:dict1.allKeys[j]] objectForKey:@"Category"];
                        a.categoryPost = cat;
                        
                        
                        NSString *tit =[[dict1 objectForKey:dict1.allKeys[j]] objectForKey:@"Title"];
                        a.Title = tit;
                        NSString *com =[[dict1 objectForKey:dict1.allKeys[j]] objectForKey:@"Comment"];
                        a.Comment = com;
                        NSString *dat =dict1.allKeys[j];
                        a.dateID = dat;
                        [userMembersArray addObject:a];
                        //       [self.collectionView reloadData];
                        
                        FIRStorage *storage = [FIRStorage storage];
                        FIRStorageReference *storageRef = [storage reference];
                        
                        NSString *downURL = [a.uID stringByAppendingString: @"/"];
                        downURL = [downURL stringByAppendingString: a.dateID];
                        downURL = [downURL stringByAppendingString: @".PNG"];
                        FIRStorageReference *islandRef = [storageRef child:downURL];
                        
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                            if (error != nil) {
                                // Uh-oh, an error occurred!
                            } else {
                                // Data for "images/island.jpg" is returned
                                UIImage *islandImage = [UIImage imageWithData:data];
                                NSString *key = [islandRef.fullPath substringToIndex:[islandRef.fullPath length]-4];
                                [imagePosts setValue:islandImage forKeyPath:key];
                                [self.collectionView reloadData];
                                
                            }
                        }];
                        
                        
                        downURL = [a.uID stringByAppendingString: @"/profileImage.PNG"];
                        islandRef = [storageRef child:downURL];
                        
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                            if (error != nil) {
                                // Uh-oh, an error occurred!
                            } else {
                                // Data for "images/island.jpg" is returned
                                UIImage *islandImage = [UIImage imageWithData:data];
                                NSString *key = [islandRef.fullPath substringToIndex:[islandRef.fullPath length]-17];
                                [imageProfiles setValue:islandImage forKeyPath:key];
                                [self.collectionView reloadData];
                                
                            }
                        }];
                    }
                }
                [self.collectionView reloadData];
                
            }
            
            NSLog(@"Success!");
            
        }];
        
        [[_ref child:@"users"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            arrayAccounts = snapshot.value;
            // ...
            //      [self.collectionView reloadData];
            
            NSLog(@"Success!");
            
        }];
        
       
    }];
    
     [refreshControl endRefreshing];
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

#pragma UICollectionViewDataSource

int array_remove[1000];
int count_remove = 0;



-(void) searchClicked:(id)sender{
    if(enteredLocation.length == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select the location" message:@"Please make sure you did select the location." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            
        }];
        [alert addAction:actAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        for(int i=0;i<userMembersArray.count; i++)
        {
            NSString *idOfcurrent = [userMembersArray[i] uID];
            NSDictionary *Curuser =[arrayAccounts objectForKey:idOfcurrent];
            NSString *loca = [Curuser objectForKey:@"location"];
            if([enteredLocation isEqualToString:loca] == NO)
            {
                array_remove[count_remove] = i;
                count_remove ++;
            }
        }
        for(int i=count_remove-1;i>=0;i--)
        {
            [userMembersArray removeObjectAtIndex:i];
        }
        [self.collectionView reloadData];
    }
}

-(NSInteger) collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section{
    return userMembersArray.count;
}
-(__kindof UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CollectionViewCell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    
    [cell.postTitle setText:[userMembersArray[indexPath.row] Title]];
    [cell.postText setText:[userMembersArray[indexPath.row] Comment] ];
    NSString *idOfcurrent = [userMembersArray[indexPath.row] uID];
    NSDictionary *Curuser =[arrayAccounts objectForKey:idOfcurrent];
    [cell.profileName setText:[Curuser objectForKey:@"name"]];
    NSString *key = [idOfcurrent stringByAppendingString:@"/profileImage.PNG"];
    if([imageProfiles objectForKey:idOfcurrent]!=nil)
    {
        [cell.avatarImage setImage:[imageProfiles objectForKey:idOfcurrent]];
    }
    else
    {
        [cell.avatarImage setImage:[UIImage imageNamed:@"Background_home.PNG"]];
   }
       
    key = [idOfcurrent stringByAppendingString:@"/"];
    key = [key stringByAppendingString:[userMembersArray[indexPath.row] dateID]];
    if([imagePosts objectForKey:key]!=nil)
    {
        [cell.postImage setImage:[imagePosts objectForKey:key]];
    }
    else{
        [cell.postImage setImage:[UIImage imageNamed:@"Background_home.PNG"]];
    }
    return cell;
}

- (CGSize) collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth/2-5;
    
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


#pragma UICollectionViewDelegate
-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    userMember *a = [userMember alloc];
    a = userMembersArray[indexPath.row];
    
    selectedID =  a.uID;
    selectedDate = a.dateID;
    selectedTitle = a.Title;
    selectedComment = a.Comment;
    
    NSString *key = [a.uID stringByAppendingString:@"/profileImage.PNG"];
    if([imageProfiles objectForKey:a.uID]!=nil)
        selectedProfileImage = [imageProfiles objectForKey:a.uID];

    
    key = [a.uID stringByAppendingString:@"/"];
    key = [key stringByAppendingString:[userMembersArray[indexPath.row] dateID]];
    if([imagePosts objectForKey:key]!=nil)
        selectedPostImage = [imagePosts objectForKey:key];
    selectedCategory = a.categoryPost;
    
    
//    selectedPostImage = imagePosts
    PostViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PostViewController"];
    
    
    NSString *idOfcurrent = [userMembersArray[indexPath.row] uID];
    NSDictionary *Curuser =[arrayAccounts objectForKey:idOfcurrent];
    NSString *key1 = [idOfcurrent stringByAppendingString:@"/profileImage.PNG"];
    if([imageProfiles objectForKey:idOfcurrent]!=nil)
    {
        apvc.profilePreIm =  [imageProfiles objectForKey:idOfcurrent];
    }
    else
    {
        apvc.profilePreIm = nil;
    }
    
    key = [idOfcurrent stringByAppendingString:@"/"];
    key = [key stringByAppendingString:[userMembersArray[indexPath.row] dateID]];
    if([imagePosts objectForKey:key]!=nil)
    {
        apvc.postPreIm = [imagePosts objectForKey:key];
    }
    else{
        apvc.postPreIm = nil;
    }
    [self.navigationController pushViewController:apvc animated:YES];
    
}




@end
