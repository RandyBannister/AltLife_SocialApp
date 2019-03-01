//
//  PeopleViewController.h
//  AltLife
//
//  Created by BradReed on 10/12/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
@import Firebase;

@interface PeopleViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, SlideNavigationControllerDelegate>
@property (strong, nonatomic) FIRDatabaseReference *ref;
- (IBAction)onFilter:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
