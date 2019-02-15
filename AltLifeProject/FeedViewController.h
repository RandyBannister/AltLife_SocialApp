//
//  FeedViewController.h
//  AltLife
//
//  Created by BradReed on 10/5/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CViewFlowLayout.h"
@import Firebase;
@interface FeedViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
-(void) searchClicked:(id)sender;
@end
