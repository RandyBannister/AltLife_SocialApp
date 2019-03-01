//
//  AppDelegate.m
//  AltLife
//
//  Created by BradReed on 10/3/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "FilterSlideViewController.h"
#import "ViewController.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import <UserNotifications/UserNotifications.h>
#import "HomeViewController.h"
#import "HomeTabbarController.h"

@import Firebase;
//@import FirebaseMessaging;

@interface AppDelegate ()
@end
int firstLogin = -1;
int ifSignUp = 0;
UIImage * myProfileImage;
NSString *nameMyProfile, *locationMyProfile;
NSArray *interestingList;
NSString *explainString;
int privateModeMyProfile = 0;
NSNumber *followersMyProfile, *followingMyProfile;
NSArray *selectedCategory;
int clickedCategory;
NSString *enteredLocation;
int arraySearchInteresting[] = {0,0,0,0,0,0,0,0};
NSString *filterLocation;

NSString *Curemail, *Curpwd;

int paidMyProfile = 0;

NSString *selectedTitle, *selectedComment, *selectedDate;
NSString *selectedID;
UIImage *selectedPostImage,*selectedProfileImage;

NSString *selectedPeopleID;
NSDictionary *selectedPeopleArray;

NSArray *followerPeople;
NSArray *followingPeople;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure];
    //[FIRMessaging messaging].delegate = self;
    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey: @"AIzaSyAgKIfav6fXSWsrI4B5GY4onYdZ2bJ6ahk"];
    
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [[SlideNavigationController sharedInstance] setNavigationBarHidden:YES];


    
   
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]){
        firstLogin = 1;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ViewController* apvc;
        apvc = [storyBoard instantiateViewControllerWithIdentifier:@"LoginView"];
        
        
        [[SlideNavigationController sharedInstance] pushViewController:apvc animated:NO];
        [[SlideNavigationController sharedInstance] setNavigationBarHidden:YES];
        
        FilterSlideViewController *filterView = [storyBoard instantiateViewControllerWithIdentifier:@"FilterView"];
        [SlideNavigationController sharedInstance].rightMenu = filterView;
    }
    else
    {
        FIRDatabaseReference *ref = [[FIRDatabase database] reference];
        firstLogin = 0;
        
        Curemail = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
        Curpwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        if(Curpwd.length ==0 || Curpwd.length == 0)
        {
            ViewController* apvc;
            apvc = [storyBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            
            
            [[SlideNavigationController sharedInstance] pushViewController:apvc animated:NO];
            [[SlideNavigationController sharedInstance] setNavigationBarHidden:YES];
            
            FilterSlideViewController *filterView = [storyBoard instantiateViewControllerWithIdentifier:@"FilterView"];
            [SlideNavigationController sharedInstance].rightMenu = filterView;
        }
        else
        if(firstLogin == 0){
            [[FIRAuth auth] signInWithEmail:Curemail
                                   password:Curpwd
                                 completion:^(FIRUser *user, NSError *error) {
                                     
                                 
                                     FIRStorage *storage = [FIRStorage storage];
                                     FIRStorageReference *storageRef = [storage reference];
                                     NSString *downURL = [user.uid stringByAppendingString: @"/profileImage.PNG"];
                                     FIRStorageReference *islandRef = [storageRef child:downURL];
                                     
                                     // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                                     [islandRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                                         if (error != nil) {
                                             // Uh-oh, an error occurred!
                                         } else {
                                             // Data for "images/island.jpg" is returned
                                             UIImage *islandImage = [UIImage imageWithData:data];
                                             myProfileImage = islandImage;
                                             
                                             
                                         }
                                     }];
                                     
                                     
                                     [[[ref child:@"users"] child:[FIRAuth auth].currentUser.uid]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                         NSDictionary *postDict = snapshot.value;
                                         // ...
                                         nameMyProfile = [postDict objectForKey:@"name"];
                                         explainString = [postDict objectForKey:@"explain"];
                                         locationMyProfile = [postDict objectForKey:@"location"];
                                         interestingList = [postDict objectForKey:@"interesting"];
                                         NSNumber *isPaid = [postDict objectForKey:@"isPaid"];
                                         
                                         paidMyProfile = [isPaid integerValue];
                                         followersMyProfile = [postDict objectForKey:@"followers"];
                                         followingMyProfile = [postDict objectForKey:@"following"];
                                         
                                         followingPeople = [postDict objectForKey:@"followingPeople"];
                                         followerPeople = [postDict objectForKey:@"followerPeople"];
                                         
                                         privateModeMyProfile = [[postDict objectForKey:@"private"] intValue];
                                         
                                         HomeViewController* apvc = [storyBoard instantiateViewControllerWithIdentifier:@"hometabbar"];
                                         [[SlideNavigationController sharedInstance] pushViewController:apvc animated:YES];
                                         [[SlideNavigationController sharedInstance] setNavigationBarHidden:YES];
                                         
                                         FilterSlideViewController *filterView = [storyBoard instantiateViewControllerWithIdentifier:@"FilterView"];
                                         [SlideNavigationController sharedInstance].rightMenu = filterView;
                                         
                                         NSLog(@"Success!");
                                         
                                     }];
                                     
                                     
                                     // If login success!!!
                                     
                                     
                                     
                                     
                                     
                                 }];
        }
        
        
        
        
    }
    
    
   // [FIRMessaging messaging].delegate = self;
    
 /*
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(!error)
            {
                NSLog(@"Success!");

                
            }
            else{
                NSLog(@"Error!");
            }
        }];
#endif
    }

    [application registerForRemoteNotifications];*/
//    [application isRegisteredForRemoteNotifications];
    
 //   [[UIApplication sharedApplication] registerForRemoteNotifications];

/*
    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
    NSLog(@"FCM registration token: %@", fcmToken);
    */
//        [FIRMessaging messaging].shouldEstablishDirectChannel = TRUE;
    return YES;
}

/*
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Pass device token to auth.
    NSLog(@"%@", deviceToken);
    [[FIRAuth auth] setAPNSToken:deviceToken type:FIRAuthAPNSTokenTypeProd];
    // Further handling of the device token if needed by the app.
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)notification
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Pass notification to auth and check if they can handle it.
    if ([[FIRAuth auth] canHandleNotification:notification]) {
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }
    // This notification is not auth related, developer should handle it.
}*/
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"AltLife"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
