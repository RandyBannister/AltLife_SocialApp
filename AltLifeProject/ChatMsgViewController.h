//
//  ChatMsgViewController.h
//  AltLifeProject
//
//  Created by Mobile Star on 11/1/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface ChatMsgViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
