//
//  FilterSlideViewController.h
//  AltLifeProject
//
//  Created by Mobile Star on 10/31/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <MapKit/MapKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import "CLPlacemark+HNKAdditions.h"

@interface FilterSlideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
- (IBAction)onDone:(id)sender;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;

@property (weak, nonatomic) IBOutlet UIButton *caBtn;
@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UIButton *hoBtn;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *boBtn;
@property (weak, nonatomic) IBOutlet UIButton *chBtn;
@property (weak, nonatomic) IBOutlet UIButton *frBtn;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (weak, nonatomic) IBOutlet UIButton *swBtn;
- (IBAction)onCA:(id)sender;
- (IBAction)onHO:(id)sender;
- (IBAction)onBD:(id)sender;
- (IBAction)onTop:(id)sender;
- (IBAction)onBo:(id)sender;
- (IBAction)onCh:(id)sender;
- (IBAction)onFr:(id)sender;
- (IBAction)onSW:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bdBtn;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@end
