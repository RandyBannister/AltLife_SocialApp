//
//  AccountViewController.h
//  AltLife
//
//  Created by BradReed on 10/13/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <MapKit/MapKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import <StoreKit/StoreKit.h>
#import "CLPlacemark+HNKAdditions.h"


@import Firebase;

@interface AccountViewController : UIViewController <UITextViewDelegate,UIImagePickerControllerDelegate, UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource,SKProductsRequestDelegate, SKPaymentTransactionObserver, UITextFieldDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
- (IBAction)onFollowing:(id)sender;
- (IBAction)onFollower:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *countOfFollowing;
@property (weak, nonatomic) IBOutlet UILabel *countOfFollower;
- (IBAction)onSwinging:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UIButton *swingingBtn;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraIcon;
@property (weak, nonatomic) IBOutlet UIButton *friendsBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)onEdit:(id)sender;
- (IBAction)onFriends:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bdsmBtn;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
- (IBAction)onTop:(id)sender;
- (IBAction)onBottom:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
- (IBAction)onChat:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *explain;
- (IBAction)onEditLocation:(id)sender;
- (IBAction)onbdsm:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameString;
- (IBAction)onPrivate:(id)sender;
- (IBAction)onHookUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hookupBtn;
@property (weak, nonatomic) IBOutlet UILabel *locationString;

@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (weak, nonatomic) IBOutlet UISwitch *privateMode;
- (IBAction)onTakePhoto:(id)sender;
- (IBAction)onCasual:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *casualBtn;

@end
