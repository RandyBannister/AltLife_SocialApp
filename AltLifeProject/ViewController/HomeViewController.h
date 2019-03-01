//
//  HomeViewController.h
//  AltLife
//
//  Created by BradReed on 10/3/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewController.h"
#import "CategoryViewController.h"
#import "DiscussionViewController.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <MapKit/MapKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>

#import "CLPlacemark+HNKAdditions.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)onDis:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)onCate:(id)sender;
- (IBAction)onFeed:(id)sender;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (weak, nonatomic) IBOutlet UIImageView *topBack;
@property (weak, nonatomic) IBOutlet UIButton *FeedButton;
@property (weak, nonatomic) IBOutlet UIButton *CategoriedButton;
@property (weak, nonatomic) IBOutlet UIButton *DiscussionsButton;
@property (weak, nonatomic) IBOutlet UIImageView *redLine;
@property (nonatomic) FeedViewController *feedview;
@property (nonatomic) CategoryViewController *cateView;
@property (nonatomic) DiscussionViewController *disview;
- (IBAction)onPlus:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *subViewController;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UITableView *tableLocation;
@end
