//
//  PeopleViewController.m
//  AltLife
//
//  Created by BradReed on 10/12/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "PeopleViewController.h"
#import "PeopleViewCell.h"
#import "CViewFlowLayout.h"
#import "UserAccountViewController.h"
extern int paidMyProfile;

extern NSArray *interestingList;
extern NSString *selectedPeopleID;
extern NSDictionary *selectedPeopleArray;

@interface PeopleViewController (){
    NSMutableArray *arrayPeople;
    NSMutableArray *arrayKeys;
    NSMutableDictionary *dict;
    UIRefreshControl *refreshControl;

}

@end

int flag = 0;
extern int arraySearchInteresting[8];
extern NSString *filterLocation;

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayPeople = [[NSMutableArray alloc] init];
    arrayKeys = [[NSMutableArray alloc] init];
    dict = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view.
    

    UITabBarController *tapbar = self.tabBarController;
    [tapbar setDelegate:self];
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                                          green:240.0f/255.0f
                                                           blue:245.0f/255.0f
                                                          alpha:1.0f];
    
    
    CGRect viewRect = self.view.bounds;
    [_collectionView setFrame:CGRectMake(5, 79, viewRect.size.width-10, viewRect.size.height-135)];
    [_collectionView registerNib:[UINib nibWithNibName:@"PeopleViewCell" bundle:nil] forCellWithReuseIdentifier:@"PeopleViewCell"];
    
    CViewFlowLayout *f1 = [[CViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = f1;
    [self.collectionView reloadData];
    _collectionView.layer.masksToBounds = YES;
    _collectionView.layer.cornerRadius = 6;
    self.ref = [[FIRDatabase database] reference];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    
    
    
    [[_ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [arrayPeople removeAllObjects];
        [arrayKeys removeAllObjects];
        [dict removeAllObjects];
        NSDictionary *postDict = snapshot.value;
        NSArray *keys= [postDict allKeys];
        
        for(int i=0;i<keys.count;i++)
        {
            flag = 0;
            NSLog(@"%@",[postDict objectForKey:[keys objectAtIndex:i]]);
            NSDictionary *eachUsers =[postDict objectForKey:[keys objectAtIndex:i]];
            
            if(![[FIRAuth auth].currentUser.uid isEqualToString:[keys objectAtIndex:i]]){
                NSArray *arrayInteresting = [eachUsers objectForKey:@"interesting"];
                if([self checkInteresting:arrayInteresting forCheck:interestingList]==YES){
                    if((paidMyProfile == 0 && [[eachUsers objectForKey:@"private"]intValue] == 0)
                       || paidMyProfile == 1)
                    [arrayPeople addObject:eachUsers];
                    [arrayKeys addObject:keys[i]];
                    FIRStorage *storage = [FIRStorage storage];
                    FIRStorageReference *storageRef = [storage reference];
                    NSString *downURL = [keys[i] stringByAppendingString: @"/profileImage.PNG"];
                    FIRStorageReference *islandRef = [storageRef child:downURL];
                    
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                        if (error != nil) {
                            // Uh-oh, an error occurred!
                        } else {
                            // Data for "images/island.jpg" is returned
                            flag = 1;
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
            }
            
        }
        
        
    }];

    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Closed %@", menu);
        [self refreshFilter];
    }];

}

-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if(viewController == self){
        
    }

    return YES;

}

-(BOOL) slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

-(void) startRefresh{
    [[_ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [arrayPeople removeAllObjects];
        [arrayKeys removeAllObjects];

        [dict removeAllObjects];
        [self.collectionView reloadData];
        NSDictionary *postDict = snapshot.value;
        NSArray *keys= [postDict allKeys];
        
        for(int i=0;i<keys.count;i++)
        {
            flag = 0;
            NSLog(@"%@",[postDict objectForKey:[keys objectAtIndex:i]]);
            NSDictionary *eachUsers =[postDict objectForKey:[keys objectAtIndex:i]];
            
            if(![[FIRAuth auth].currentUser.uid isEqualToString:[keys objectAtIndex:i]]){
                NSArray *arrayInteresting = [eachUsers objectForKey:@"interesting"];
                if([self checkInteresting:arrayInteresting forCheck:interestingList]==YES){
                    [arrayPeople addObject:eachUsers];
                    [arrayKeys addObject:keys[i]];
                    FIRStorage *storage = [FIRStorage storage];
                    FIRStorageReference *storageRef = [storage reference];
                    NSString *downURL = [keys[i] stringByAppendingString: @"/profileImage.PNG"];
                    FIRStorageReference *islandRef = [storageRef child:downURL];
                    
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                        if (error != nil) {
                            // Uh-oh, an error occurred!
                        } else {
                            // Data for "images/island.jpg" is returned
                            flag = 1;
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
            }
        [_collectionView reloadData];
            
        }
        
        
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

-(void) refreshFilter{
    
    NSMutableArray *arrayFilter = [[NSMutableArray alloc]init];
    for(int i=0;i<8;i++)
        [arrayFilter addObject:[NSNumber numberWithInt:arraySearchInteresting[i]]];
    [[_ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [arrayPeople removeAllObjects];
        [arrayKeys removeAllObjects];
        
        [dict removeAllObjects];
        [self.collectionView reloadData];
        NSDictionary *postDict = snapshot.value;
        NSArray *keys= [postDict allKeys];
        
        for(int i=0;i<keys.count;i++)
        {
            flag = 0;
            NSLog(@"%@",[postDict objectForKey:[keys objectAtIndex:i]]);
            NSDictionary *eachUsers =[postDict objectForKey:[keys objectAtIndex:i]];
            NSString *locationFilt = [eachUsers objectForKey:@"location"];
            if(![[FIRAuth auth].currentUser.uid isEqualToString:[keys objectAtIndex:i]]){
                NSArray *arrayInteresting = [eachUsers objectForKey:@"interesting"];
                if([self checkInteresting:arrayInteresting forCheck:arrayFilter]==YES  && [locationFilt isEqualToString:filterLocation]){
                    [arrayPeople addObject:eachUsers];
                    [arrayKeys addObject:keys[i]];
                    FIRStorage *storage = [FIRStorage storage];
                    FIRStorageReference *storageRef = [storage reference];
                    NSString *downURL = [keys[i] stringByAppendingString: @"/profileImage.PNG"];
                    FIRStorageReference *islandRef = [storageRef child:downURL];
                    
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                        if (error != nil) {
                            // Uh-oh, an error occurred!
                        } else {
                            // Data for "images/island.jpg" is returned
                            flag = 1;
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
            }
            [_collectionView reloadData];
            
        }
        
        
    }];
    [refreshControl endRefreshing];
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

    if([dict objectForKey:arrayKeys[indexPath.row]]!=nil)
    {
        [cell.imageView setImage:[dict objectForKey:arrayKeys[indexPath.row]]];
        [cell.imageAvatar setImage:[dict objectForKey:arrayKeys[indexPath.row]]];
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

-(BOOL) checkInteresting:(NSArray *)array1 forCheck:(NSArray *)array2{
    
    for(int i=0;i<array1.count;i++){
        if([[array1 objectAtIndex:i] isEqualToNumber:[NSNumber numberWithInteger: 1]] && [[array2 objectAtIndex:i] isEqualToNumber:[NSNumber numberWithInteger: 1]]){
            return YES;
        }
    }
    
    return NO;
}

-(IBAction) onDoneFilter:(id)sender{
    NSLog(@"Clicked");
    
}
#pragma UICollectionViewDelegate
-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    selectedPeopleID = arrayKeys[indexPath.row];
    selectedPeopleArray  = arrayPeople[indexPath.row];
    UserAccountViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAccountViewController"];
    [self.navigationController pushViewController:apvc animated:YES];
    
}

- (IBAction)onFilter:(id)sender {
    [[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:^{
    }];
}
@end
