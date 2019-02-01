//
//  AccountViewController.m
//  AltLife
//
//  Created by BradReed on 10/13/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "AccountViewController.h"
#import "SomeoneFollower.h"
#import <IAPManager.h>


@interface AccountViewController (){
    UITextField *textName;
    UITextField *textLocation;

}
@property (strong, nonatomic) NSArray *searchResults;

@end

static NSString *const kHNKDemoSearchResultsCellIdentifier = @"HNKDemoSearchResultsCellIdentifier";
extern int paidMyProfile;
extern int ifSignUp;
extern int privateModeMyProfile;
extern NSString *nameMyProfile;
extern NSString *locationMyProfile;
extern UIImage *myProfileImage;
extern NSString *explainString;
extern NSArray *interestingList;

int changed = 0;
int interestingCount = 0;
int array1[] = {0,0,0,0,0,0,0,0};

@implementation AccountViewController


-(NSString*)numberWithShortcut1:(NSNumber*)number
{
    unsigned long long value = [number longLongValue];
    
    NSUInteger index = 0;
    double dvalue = (double)value;
    
    NSArray *suffix = @[ @"", @"K", @"M", @"B", @"T", @"P", @"E" ];
    
    while ((value /= 1000) && ++index) dvalue /= 1000;
    
    NSString *svalue = [NSString stringWithFormat:@"%@%@",[NSNumber numberWithInt:dvalue], [suffix objectAtIndex:index]];
    
    return svalue;
}

-(void) viewWillAppear:(BOOL)animated{
    
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}
- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            //if you have more than one in-app purchase product,
            //you restore the correct product for the identifier.
            //For example, you could use
            //if(productID == kRemoveAdsProductIdentifier)
            //to get the product identifier for the
            //restored purchases, you can use
            //
            //NSString *productID = transaction.payment.productIdentifier;
         //   [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        //if you have multiple in app purchases in your app,
        //you can get the product identifier of this transaction
        //by using transaction.payment.productIdentifier
        //
        //then, check the identifier against the product IDs
        //that you have defined to check which product the user
        //just purchased
        
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
               // [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                
                if(privateModeMyProfile == 0)
                    privateModeMyProfile = 1;
                else if(privateModeMyProfile == 1)
                    privateModeMyProfile = 0;
                
                paidMyProfile = 1;
                [[[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid] child:@"isPaid"] setValue:[NSNumber numberWithInt:1]];
                [_privateMode setOn:YES];   //

                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                paidMyProfile = 0;
                [[[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid] child:@"isPaid"] setValue:[NSNumber numberWithInt:0]];
                [_privateMode setOn:NO];   //

                break;
            case SKPaymentTransactionStateDeferred:
                
                break;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    _explain.delegate = self;
    
    // Do any additional setup after loading the view.
    self.ref = [[FIRDatabase database] reference];   // Set Firebase Dababase handle.
    
    [self.locationTableView setHidden:YES];

    self.locationTableView.delegate = self;
    self.locationTableView.dataSource = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    
    if(ifSignUp == 0)
    {
        FIRStorage *storage = [FIRStorage storage];
        FIRStorageReference *storageRef = [storage reference];
        NSString *downURL = [[FIRAuth auth].currentUser.uid stringByAppendingString: @"/profileImage.PNG"];
        FIRStorageReference *islandRef = [storageRef child:downURL];
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                UIImage *islandImage = [UIImage imageWithData:data];
                myProfileImage = islandImage;
                [_imageProfile setImage:myProfileImage];
                
            }
        }];
        [_nameString setText:nameMyProfile];
        [_locationString setText:locationMyProfile];

        [_explain setText:explainString];
        for(int i=0; i<interestingList.count ;i++)
            array1[i] = [[interestingList objectAtIndex:i] intValue];
        
        if([[interestingList objectAtIndex:0] intValue ] == 1 )
          [ _casualBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        if([[interestingList objectAtIndex:1] intValue] ==1)
            [ _hookupBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        if([[interestingList objectAtIndex:2] intValue]==1)
            [ _bdsmBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        if([[interestingList objectAtIndex:3] intValue]==1)
            [ _topBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        if([[interestingList objectAtIndex:4] intValue] ==1)
            [ _bottomBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        if([[interestingList objectAtIndex:5] intValue] ==1)
            [ _chatBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        if([[interestingList objectAtIndex:6] intValue] ==1)
            [ _friendsBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        if([[interestingList objectAtIndex:7] intValue]==1)
            [ _swingingBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];

    }
    else if(ifSignUp == 1){
       
        [_nameString setText:nameMyProfile];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your profile"                                                                       message:@"Please complete your profile" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            
        }];
        [alert addAction:actAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }

    
    [[[_ref child:@"users"]  child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray * addArray = [[NSMutableArray alloc]init];
        NSDictionary *postDict = snapshot.value;
        NSLog(@"%@",postDict);
        
        addArray = [postDict objectForKey:@"followingPeople"];

        paidMyProfile = 0;
        
        if(addArray == nil)
            [_countOfFollowing setText:@"0"];
        else
        {
            [_countOfFollowing setText:[self numberWithShortcut1:[NSNumber numberWithInt:addArray.count]]];
            
        }
        
        addArray = [postDict objectForKey:@"followerPeople"];
        
        
        if(addArray == nil)
            [_countOfFollower setText:@"0"];
        else
        {
            [_countOfFollower setText:[self numberWithShortcut1:[NSNumber numberWithInt:addArray.count]]];
            
        }
    }];
    if(privateModeMyProfile == 0)
        [_privateMode setOn:NO];   //
    else
        [_privateMode setOn:YES];   //

  
    textName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [textName setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:textName];
    
    textLocation = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [textLocation setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:textLocation];
    
    [textLocation addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    textName.hidden = YES;
    if(explainString.length  == 0)
    {
        _explain.text = @"Please explain about you...";
        _explain.textColor = [UIColor lightGrayColor];
    }
    _explain.delegate = self;
    
    [_explain setDelegate:self];
//    [_explain sizeToFit];
    _imageProfile.layer.masksToBounds = YES;
    _imageProfile.layer.cornerRadius = _imageProfile.frame.size.width/2;
    [_imageProfile.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [_imageProfile.layer setBorderWidth:8.0];
    if(myProfileImage !=  nil)
    [_imageProfile setImage:myProfileImage];
    
    UITabBarController *tapbar = self.tabBarController;     // Tabbar Setting
    [tapbar setDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [_explain resignFirstResponder];
    [textName resignFirstResponder];
    [textLocation resignFirstResponder];
    return YES;
}


-(void) textFieldDidChange :(UITextField*)theTextField{
    if(textLocation.text.length>0){
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

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.searchBar setShowsCancelButton:NO animated:YES];
//    [self.searchBar resignFirstResponder];

    HNKGooglePlacesAutocompletePlace *selectedPlace = self.searchResults[indexPath.row];
    
    [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                       apiKey: self.searchQuery.apiKey
                                   completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                       if (placemark) {
                                           
                                           
                                           [self.locationTableView setHidden: YES];
                                           
                                           
                                           NSString *addressS = [NSString stringWithFormat:@"%@, %@, %@",placemark.locality, placemark.administrativeArea, placemark.country];
                                           NSLog(@"%@,%@,%@",placemark.country, placemark.administrativeArea, placemark.locality);
                                           
                                           [textLocation setText:addressS];
                                           
                                           //[self addPlacemarkAnnotationToMap:placemark addressString:addressString];
                                           //[self recenterMapToPlacemark:placemark];
                                           
                                           [self.locationTableView deselectRowAtIndexPath:indexPath animated:NO];
                                           
                                           if(textLocation.text.length != 0 )
                                           {
                                               [_locationString setText:textLocation.text];
                                               locationMyProfile = _locationString.text;
                                           }
                                           
                                           textLocation.hidden = YES;
                                           _locationString.hidden = NO;
                                       }
                                   }];

    
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
-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
    [[[_ref child:@"users"]  child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray * addArray = [[NSMutableArray alloc]init];
        NSDictionary *postDict = snapshot.value;
        NSLog(@"%@",postDict);
        
        addArray = [postDict objectForKey:@"followingPeople"];
        
        
        
        if(addArray == nil)
            [_countOfFollowing setText:@"0"];
        else
        {
            [_countOfFollowing setText:[self numberWithShortcut1:[NSNumber numberWithInt:addArray.count]]];
            
        }
        
        addArray = [postDict objectForKey:@"followerPeople"];
        
        
        if(addArray == nil)
            [_countOfFollower setText:@"0"];
        else
        {
            [_countOfFollower setText:[self numberWithShortcut1:[NSNumber numberWithInt:addArray.count]]];
            
        }
    }];
    
    if(viewController != self){

    
    [[FIRAuth auth]
     addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
         // ...
     }];
    
    if(ifSignUp == 1)  //if signup mode.
    {
        if(nameMyProfile.length!=0 && locationMyProfile.length != 0 && explainString.length != 0 && interestingCount!=0)
        {
            //if profile is completed.
            //save it to the server.
            ifSignUp = 0;
 
            NSMutableArray *arrayUpload = [[NSMutableArray alloc]init];
            for(int i=0;i<8;i++)
                [arrayUpload addObject:[NSNumber numberWithInt:array1[i]]];
            interestingList  = [arrayUpload copy];
            FIRUser *user = [FIRAuth auth].currentUser;
            [[[[_ref child:@"users"] child:user.uid] child:@"name"]
             setValue:nameMyProfile];
            
            [[[[_ref child:@"users"] child:user.uid] child:@"location"]
             setValue:locationMyProfile];
            explainString = _explain.text;
            [[[[_ref child:@"users"] child:user.uid] child:@"explain"] setValue:explainString];
            [[[[_ref child:@"users"] child:user.uid] child:@"interesting"] setValue:arrayUpload];
            
            
            FIRStorage *storage = [FIRStorage storage];
            FIRStorageReference *storageRef = [storage reference];
            NSData *data = UIImagePNGRepresentation(myProfileImage);
            NSString *uploadURL = [user.uid stringByAppendingString:@"/profileImage.PNG"];
            FIRStorageReference *riversRef = [storageRef child:uploadURL];
            FIRStorageUploadTask *uploadTask = [riversRef putData:data
                                                         metadata:nil
                                                       completion:^(FIRStorageMetadata *metadata,
                                                                    NSError *error) {
                                                           if (error != nil) {
                                                           } else {
                                                               
                                                               NSURL *downloadURL = metadata.downloadURL;
                                                           }
                                                       }];
            
            

            
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your profile"                                                                       message:@"Please make sure complete your profile" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                
            }];
            [alert addAction:actAlert];
            [self presentViewController:alert animated:YES completion:nil];

            return NO;
            
        }
    }
    else{
        if(changed == 1){
           //Save the changed information to the server.
            NSMutableArray *arrayUpload = [[NSMutableArray alloc]init];;
            for(int i=0;i<8;i++)
                [arrayUpload addObject:[NSNumber numberWithInt:array1[i]]];
            interestingList = [arrayUpload copy];
            
            FIRUser *user = [FIRAuth auth].currentUser;
            [[[[_ref child:@"users"] child:user.uid] child:@"name"]
             setValue:nameMyProfile];
            
            [[[[_ref child:@"users"] child:user.uid] child:@"location"]
             setValue:locationMyProfile];
            explainString = _explain.text;
            
            [[[[_ref child:@"users"] child:user.uid] child:@"explain"] setValue:explainString];
            [[[[_ref child:@"users"] child:user.uid] child:@"interesting"] setValue:arrayUpload];
            
            if(myProfileImage != nil){
            FIRStorage *storage = [FIRStorage storage];
            FIRStorageReference *storageRef = [storage reference];
            
            
            NSData *data = UIImagePNGRepresentation(myProfileImage);
            
            NSString *uploadURL = [user.uid stringByAppendingString:@"/profileImage.PNG"];
            
            FIRStorageReference *riversRef = [storageRef child:uploadURL];
            
            // Upload the file to the path "images/rivers.jpg"
            FIRStorageUploadTask *uploadTask = [riversRef putData:data
                                                         metadata:nil
                                                       completion:^(FIRStorageMetadata *metadata,
                                                                    NSError *error) {
                                                           if (error != nil) {
                                                               
                                                               
                                                           } else {
                                                               
                                                               NSURL *downloadURL = metadata.downloadURL;
                                                           }
                                                       }];
            }

            }
        }
        
    }
    return YES;
}

-(void) dismiss{
    [_explain resignFirstResponder];
    [_nameString resignFirstResponder];
    [_locationString resignFirstResponder];
    explainString = _explain.text;
    
    if( textName.hidden == NO )
    {
    if(textName.text.length != 0 )
    {
        [_nameString setText:textName.text];
        nameMyProfile = _nameString.text;
    }
    
    textName.hidden = YES;
    _nameString.hidden = NO;
    }
    if( textLocation.hidden == NO )
    {
        if(textLocation.text.length != 0 )
        {
            [_locationString setText:textLocation.text];
            locationMyProfile = _locationString.text;
        }
        
        textLocation.hidden = YES;
        _locationString.hidden = NO;
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    myProfileImage = chosenImage;
    [_imageProfile setImage:chosenImage];

    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
        changed = 1;
//    _explain.text = @"";
    _explain.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_explain.text.length == 0){
        _explain.textColor = [UIColor lightGrayColor];
//        _explain.text = @"Write something...";
//        [_explain resignFirstResponder];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onEdit:(id)sender {
        changed = 1;
    CGRect cc = [_nameString convertRect:_nameString.bounds toView:self.view];
    [textName setFrame: cc];
    _nameString.hidden = YES;
    textName.hidden = NO;
    [textName setText:_nameString.text];
    [textName selectAll:nil];
}


- (IBAction)onEditLocation:(id)sender {
        changed = 1;
    CGRect cc = [_locationString convertRect:_locationString.bounds toView:self.view];
    [textLocation setFrame: cc];
    _locationString.hidden = YES;
    textLocation.hidden = NO;
    [textLocation setText:_locationString.text];
    [textLocation selectAll:nil];
    

    
}


- (IBAction)onPrivate:(id)sender {
        changed = 1;

    [[[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid] child:@"private"] setValue:[NSNumber numberWithInt:privateModeMyProfile]];
    if(paidMyProfile == 0)
    {
        if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        //If you have more than one in-app purchase, and would like
        //to have the user purchase a different product, simply define
        //another function and replace kRemoveAdsProductIdentifier with
        //the identifier for the other product
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"AltlifeMonthlyPayment"]];
        productsRequest.delegate = self;
        [productsRequest start];
        
        }
        else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
        }
    }
    else{
        paidMyProfile = 1;
         [[[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid] child:@"isPaid"] setValue:[NSNumber numberWithInt:1]];
        if(privateModeMyProfile == 0)
            privateModeMyProfile = 1;
        else if(privateModeMyProfile == 1)
            privateModeMyProfile = 0;
    }
    
    
}


- (IBAction)onTakePhoto:(id)sender {
        changed = 1;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose"                                                               message:@"Please choose one." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Take a new photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }];
    UIAlertAction *actAlert1 = [UIAlertAction actionWithTitle:@"Choose from existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    [alert addAction:actAlert];    [alert addAction:actAlert1];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onCasual:(id)sender {
    changed = 1;
    if(array1[0] ==1)
    {
        [_casualBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.PNG"] forState:UIControlStateNormal];
        array1[0] = 0;
        interestingCount--;
    }
    else{
        
        [_casualBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        array1[0] = 1;
        interestingCount++;
    }

}
- (IBAction)onHookUp:(id)sender {
    changed = 1;
    if(array1[1] == 1)
    {
        [_hookupBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.PNG"] forState:UIControlStateNormal];
        array1[1] = 0;
        interestingCount--;
    }
    else{
        
        [_hookupBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        array1[1] = 1;
        interestingCount++;
    }
}
- (IBAction)onbdsm:(id)sender {
        changed = 1;
    if(array1[2] == 1)
    {
        [_bdsmBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.PNG"] forState:UIControlStateNormal];
        array1[2] = 0;
        interestingCount--;
    }
    else{
        
        [_bdsmBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        array1[2] = 1;
        interestingCount++;
    }
}
- (IBAction)onTop:(id)sender {
        changed = 1;
    if(array1[3] == 1)
    {
        [_topBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.PNG"] forState:UIControlStateNormal];
        array1[3] = 0;
        interestingCount--;
    }
    else{
        
        [_topBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        array1[3] = 1;
        interestingCount++;
    }

}

- (IBAction)onBottom:(id)sender {
        changed = 1;
    if(array1[4] == 1)
    {
        [_bottomBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.PNG"] forState:UIControlStateNormal];
        array1[4] = 0;
        interestingCount--;
    }
    else{
        
        [_bottomBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        array1[4] = 1;
        interestingCount++;
    }
}
- (IBAction)onChat:(id)sender {
        changed = 1;
    if(array1[5] == 1)
    {
        [_chatBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.png"] forState:UIControlStateNormal];
        array1[5] = 0;
        interestingCount--;
    }
    else{
        
        [_chatBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        array1[5] = 1;
        interestingCount++;
    }
}
- (IBAction)onFriends:(id)sender {
        changed = 1;
    if(array1[6] == 1)
    {
        [_friendsBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.PNG"] forState:UIControlStateNormal];
        array1[6] = 0;
        interestingCount--;
    }
    else{
        
        [_friendsBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        array1[6] = 1;
        interestingCount++;
    }
    
}
- (IBAction)onSwinging:(id)sender {
        changed = 1;
    if(array1[7] == 1)
    {
        [_swingingBtn setImage:[UIImage imageNamed:@"uncheckedinteresting.PNG"] forState:UIControlStateNormal];
        array1[7] = 0;
        interestingCount--;
    }
    else{
        
        [_swingingBtn setImage:[UIImage imageNamed:@"checkedinter.png"] forState:UIControlStateNormal];
        array1[7] = 1;
        interestingCount++;
    }
}

- (IBAction)onFollowing:(id)sender {
    SomeoneFollower* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"someonefollower"];
    apvc.followID = [[FIRAuth auth] currentUser].uid;
    apvc.isFollower = 0;
    apvc.isMe = 1;
    [self.navigationController pushViewController:apvc animated:YES];

}

- (IBAction)onFollower:(id)sender {
    SomeoneFollower* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"someonefollower"];
    apvc.followID = [[FIRAuth auth] currentUser].uid;
    apvc.isFollower = 1;
    apvc.isMe = 1;
    [self.navigationController pushViewController:apvc animated:YES];

}
@end
