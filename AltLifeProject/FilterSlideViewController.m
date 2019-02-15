//
//  FilterSlideViewController.m
//  AltLifeProject
//
//  Created by Mobile Star on 10/31/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "FilterSlideViewController.h"
#import "PeopleViewController.h"

@interface FilterSlideViewController ()
@property (strong, nonatomic) NSArray *searchResults;

@end

extern int arraySearchInteresting[8];
extern NSString *filterLocation;
static NSString *const kHNKDemoSearchResultsCellIdentifier = @"HNKDemoSearchResultsCellIdentifier2";

@implementation FilterSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationText.delegate = self;
    self.locationTableView.hidden = YES;
    self.locationTableView.delegate = self;
    self.locationTableView.dataSource = self;

    // Do any additional setup after loading the view.
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    [_locationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
 //  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
 //   [self.view addGestureRecognizer:tap];
 //   tap.cancelsTouchesInView = NO;


}
-(void) dismiss{
    [_locationTableView setHidden:YES];
    [_locationText resignFirstResponder];

}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [_locationText resignFirstResponder];
    return YES;
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
-(void) textFieldDidChange :(UITextField*)theTextField{
    if(_locationText.text.length>0){
        [self.locationTableView setHidden:NO];
        [self.searchQuery fetchPlacesForSearchQuery: theTextField.text
                                         completion:^(NSArray *places, NSError *error) {
                                             if (error) {
                                                 NSLog(@"ERROR: %@", error);
                                                 [self handleSearchError:error];
                                             } else {
                                                 self.searchResults = places;
                                                 [self.locationTableView reloadData];
                                             }
                                         }];
    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    HNKGooglePlacesAutocompletePlace *selectedPlace = self.searchResults[indexPath.row];
    
    [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                       apiKey: self.searchQuery.apiKey
                                   completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                       if (placemark) {
                                           
                                           
                                           [self.locationTableView setHidden: YES];
                                           
                                           
                                           NSString *addressS = [NSString stringWithFormat:@"%@, %@, %@",placemark.locality, placemark.administrativeArea, placemark.country];
                                           NSLog(@"%@,%@,%@",placemark.country, placemark.administrativeArea, placemark.locality);
                                           
                                           [_locationText setText:addressS];
                                           
                                           filterLocation = addressS;
                                           [self.locationTableView deselectRowAtIndexPath:indexPath animated:NO];
                                           
                                         //  if(textLocation.text.length != 0 )
                                           //{
                                             //  [_locationString setText:textLocation.text];
                                              // locationMyProfile = _locationString.text;
                                           //}
                                           
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

- (IBAction)onDone:(id)sender {
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        
    }];
}
- (IBAction)onCA:(id)sender {
    if(arraySearchInteresting[0] == 1)
    {
        arraySearchInteresting[0] = 0;
        [_caBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    }
    else{
        arraySearchInteresting[0] = 1;
        [_caBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];

    }
}

- (IBAction)onHO:(id)sender {
    if(arraySearchInteresting[1] == 1)
    {
        arraySearchInteresting[1] = 0;
        [_hoBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    }
    else{
        arraySearchInteresting[1] = 1;
        [_hoBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)onBD:(id)sender {
    if(arraySearchInteresting[2] == 1)
    {
        arraySearchInteresting[2] = 0;
        [_bdBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    }
    else{
        arraySearchInteresting[2] = 1;
        [_bdBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)onTop:(id)sender {
    if(arraySearchInteresting[3] == 1)
    {
        arraySearchInteresting[3] = 0;
        [_topBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    }
    else{
        arraySearchInteresting[3] = 1;
        [_topBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)onBo:(id)sender {
    if(arraySearchInteresting[4] == 1)
    {
        arraySearchInteresting[4] = 0;
        [_boBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    }
    else{
        arraySearchInteresting[4] = 1;
        [_boBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)onCh:(id)sender {
    if(arraySearchInteresting[5] == 1)
    {
        arraySearchInteresting[5] = 0;
        [_chBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    }
    else{
        arraySearchInteresting[5] = 1;
        [_chBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)onFr:(id)sender {
    if(arraySearchInteresting[6] == 1)
    {
        arraySearchInteresting[6] = 0;
        [_frBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    }
    else{
        arraySearchInteresting[6] = 1;
        [_frBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)onSW:(id)sender {
    if(arraySearchInteresting[7] == 1)
    {
        arraySearchInteresting[7] = 0;
        [_swBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
    }
    else{
        arraySearchInteresting[7] = 1;
        [_swBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        
    }
}
@end
