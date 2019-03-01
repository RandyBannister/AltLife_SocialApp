//
//  HomeViewController.m
//  AltLife
//
//  Created by BradReed on 10/3/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "HomeViewController.h"
#import "FeedViewController.h"
#import "CategoryViewController.h"
#import "DiscussionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PostAds.h"

extern NSString * enteredLocation;

@interface HomeViewController ()
{
    UIView * popup;
    UIView *popup1;
    int topPosY;
}
@property (strong, nonatomic) NSArray *searchResults;

@end
extern int ifSignUp;
extern NSString *Curemail, *Curpwd;

static NSString *const kHNKDemoSearchResultsCellIdentifier = @"HNKDemoSearchResultsCellIdentifier1";

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:Curemail forKey:@"email"];
    [defaults setObject:Curpwd forKey:@"password"];

    [self.tableLocation setHidden:YES];
    
    self.tableLocation.delegate = self;
    self.tableLocation.dataSource = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    self.searchBar.delegate = self;


    
    
    UIImage *buttonImage = [UIImage imageNamed:@"Layer 26.png"];
    UIImage *highlightImage = [UIImage imageNamed:@"Layer 26.png"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];

    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        if ((int)[[UIScreen mainScreen] nativeBounds].size.height == 2436) {
                        button.frame = CGRectMake(self.tabBarController.tabBar.frame.size.width/2-buttonImage.size.width/3, self.tabBarController.tabBar.frame.origin.y-25, buttonImage.size.width/3*2, buttonImage.size.height/3*2);
            
        }
        else
            button.frame = CGRectMake(self.tabBarController.tabBar.frame.size.width/2-buttonImage.size.width/3, self.tabBarController.tabBar.frame.origin.y+5, buttonImage.size.width/3*2, buttonImage.size.height/3*2);
    }
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBarController.tabBar.frame.size.height;
/*    if (heightDifference < 0)
        button.center = self.tabBarController.tabBar.center;
    else
    {
        CGPoint center = self.tabBarController.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }*/
    [button addTarget:self action:@selector(onClickPlus:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:button];
    [self.tabBarController.view bringSubviewToFront:button];

    // Do any additional setup after loading the view.
    topPosY = 75;
    CGRect viewRect = self.view.bounds;
    
    [UITabBar appearance].tintColor = [UIColor redColor];
    
    
    [_topBack setFrame:CGRectMake(0, topPosY, viewRect.size.width, 50)];
    [_FeedButton setFrame:CGRectMake(0, topPosY+2, viewRect.size.width/3, 43)];
    [_CategoriedButton setFrame:CGRectMake(viewRect.size.width/3, topPosY+2, viewRect.size.width/3, 48)];
    [_DiscussionsButton setFrame:CGRectMake(viewRect.size.width/3*2, topPosY+2, viewRect.size.width/3,48)];
    
    
    [_redLine setFrame:CGRectMake(0, topPosY+45, viewRect.size.width, 5)];
    
    [_subViewController setFrame:CGRectMake(5, 135, viewRect.size.width-10, viewRect.size.height-185)];
    
    _feedview = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedViewCon"];
    _disview = [self.storyboard instantiateViewControllerWithIdentifier:@"DiscussionViewController"];
    _cateView = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];

    
    
    
    
    
    CGRect rect =  self.subViewController.bounds;
    [_feedview.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.subViewController addSubview:_feedview.view];
    [self addChildViewController:_feedview];
    _subViewController.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _feedview.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_feedview didMoveToParentViewController:self];
    
    [_searchButton addTarget:_feedview action:@selector(searchClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(ifSignUp == 1){
        popup = [[UIView alloc]init];
        [popup setFrame:CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height)];
        popup.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view addSubview:popup];
 
        

        popup1 = [[UIView alloc]init];
        [popup1 setFrame:CGRectMake(40 , 100, self.view.frame.size.width-80, self.view.frame.size.height-200)];
        
        UIGraphicsBeginImageContext(popup1.frame.size);
        
        [[UIImage imageNamed:@"popup.png"] drawInRect:popup1.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        popup1.backgroundColor = [[UIColor colorWithPatternImage:image] colorWithAlphaComponent:0.9f];
        
        UIButton *okBtn = [[UIButton alloc]init];
        [okBtn setFrame: CGRectMake(0, popup1.frame.size.height-70, popup1.frame.size.width, 70)];
        [okBtn setImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
        [popup1 addSubview:okBtn];
        
        popup1.layer.masksToBounds = YES;
        popup1.layer.cornerRadius = 10;
        
        [okBtn addTarget:self action:@selector(onOKCicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:popup1];
    }
    
    
}

- (void)onOKCicked:(id)sender {
    popup1.hidden = YES;
    popup.hidden = YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHNKDemoSearchResultsCellIdentifier forIndexPath:indexPath];
    
    HNKGooglePlacesAutocompletePlace *thisPlace = self.searchResults[indexPath.row];
    cell.textLabel.text = thisPlace.name;
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    HNKGooglePlacesAutocompletePlace *selectedPlace = self.searchResults[indexPath.row];
    
    [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                       apiKey: self.searchQuery.apiKey
                                   completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                       if (placemark) {
                                           
                                           
                                           [self.tableLocation setHidden: YES];
                                           
                                           
                                           NSString *addressS = [NSString stringWithFormat:@"%@, %@, %@",placemark.locality, placemark.administrativeArea, placemark.country];
                                           NSLog(@"%@,%@,%@",placemark.country, placemark.administrativeArea, placemark.locality);
                                           
                                           [_searchBar setText:addressS];
                                           enteredLocation = addressS;
                                           /*
                                           //[self addPlacemarkAnnotationToMap:placemark addressString:addressString];
                                           //[self recenterMapToPlacemark:placemark];
                                           
                                           [self.locationTableView deselectRowAtIndexPath:indexPath animated:NO];
                                           
                                           if(textLocation.text.length != 0 )
                                           {
                                               [_locationString setText:textLocation.text];
                                               locationMyProfile = _locationString.text;
                                           }
                                           
                                           textLocation.hidden = YES;
                                           _locationString.hidden = NO;*/
                                       }
                                   }];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        [self.tableLocation setHidden:NO];
        
        [self.searchQuery fetchPlacesForSearchQuery: searchText
                                         completion:^(NSArray *places, NSError *error) {
                                             if (error) {
                                                 NSLog(@"ERROR: %@", error);
                                                 [self handleSearchError:error];
                                             } else {
                                                 self.searchResults = places;
                                                 [self.tableLocation reloadData];
                                             }
                                         }];
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_feedview viewWillAppear:YES];
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.tableLocation setHidden:YES];
}


- (void)handleSearchError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) onClickPlus:(UIButton*)sender{
    
    PostAds* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"postAds"];
    [self.navigationController pushViewController:apvc animated:YES];
    
}
-(void) viewWillAppear:(BOOL)animated{


    
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

- (IBAction)onFeed:(id)sender {
    CGRect viewRect = self.view.bounds;
    
    [_FeedButton setFrame:CGRectMake(0, topPosY+2, viewRect.size.width/3, 43)];
    [_CategoriedButton setFrame:CGRectMake(viewRect.size.width/3, topPosY+2, viewRect.size.width/3, 48)];
    [_DiscussionsButton setFrame:CGRectMake(viewRect.size.width/3*2, topPosY+2, viewRect.size.width/3,48)];
   // _feedview = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedViewCon"];
    
    CGRect rect =  self.subViewController.bounds;
    [_feedview.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.subViewController addSubview:_feedview.view];
    [self addChildViewController:_feedview];
    _subViewController.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _feedview.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_feedview didMoveToParentViewController:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:237/255.0f
                                                  green:240/255.0f
                                                   blue:245/255.0f
                                                  alpha:1.0f]];

    
}

- (IBAction)onCate:(id)sender {
    CGRect viewRect = self.view.bounds;
    
    [_FeedButton setFrame:CGRectMake(0, topPosY+2, viewRect.size.width/3, 48)];
    [_CategoriedButton setFrame:CGRectMake(viewRect.size.width/3, topPosY+2, viewRect.size.width/3, 43)];
    [_DiscussionsButton setFrame:CGRectMake(viewRect.size.width/3*2, topPosY+2, viewRect.size.width/3,48)];

    CGRect rect =  self.subViewController.bounds;
    [_cateView.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
//    [self.feedview.view removeFromSuperview];
//    [self.feedview removeFromParentViewController];

    [self.subViewController addSubview:_cateView.view];
    [self addChildViewController:_cateView];
    _subViewController.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _cateView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_cateView didMoveToParentViewController:self];}

- (IBAction)onSearch:(id)sender {
    if(_searchBar.text.length == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select the location" message:@"Please make sure you did select the location." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            
        }];
        [alert addAction:actAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
    }
}

- (IBAction)onDis:(id)sender {
    CGRect viewRect = self.view.bounds;
    
    [_FeedButton setFrame:CGRectMake(0, topPosY+2, viewRect.size.width/3, 48)];
    [_CategoriedButton setFrame:CGRectMake(viewRect.size.width/3, topPosY+2, viewRect.size.width/3, 48)];
    [_DiscussionsButton setFrame:CGRectMake(viewRect.size.width/3*2, topPosY+2, viewRect.size.width/3,43)];
    
    
    
    CGRect rect =  self.subViewController.bounds;
    [_disview.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.subViewController addSubview:_disview.view];
    [self addChildViewController:_disview];
    _subViewController.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _disview.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_disview didMoveToParentViewController:self];
    
    
}


- (IBAction)onPlus:(id)sender {
}
@end
