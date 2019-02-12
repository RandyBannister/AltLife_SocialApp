//
//  ChatUIViewController.m
//  AltLifeProject
//
//  Created by Mobile Star on 11/7/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "ChatUIViewController.h"
@interface ChatUIViewController (){
        NSArray *sortedKeys1;
    NSMutableDictionary *dictSorted;
//    NSMutableArray *arrayOftexts;
}
@property (nonatomic, strong) NSMutableArray* data;

@end
extern UIImage * myProfileImage;

@implementation ChatUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableStyle:AMBubbleTableStyleFlat];
    [self setDataSource:self]; // Weird, uh?
    [self setDelegate:self];
    
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self setTitle:@"Chat"];
    self.data = [[NSMutableArray alloc] init];
    dictSorted = [[NSMutableDictionary alloc]init];
//    arrayOftexts = [[NSMutableArray alloc] init];
    [self setBubbleTableOptions:@{AMOptionsBubbleDetectionType: @(UIDataDetectorTypeAll),
                                  AMOptionsBubblePressEnabled: @NO,
                                  AMOptionsBubbleSwipeEnabled: @NO,
                                  AMOptionsButtonTextColor: [UIColor colorWithRed:1.0f green:1.0f blue:184.0f/256 alpha:1.0f]}];
    self.ref = [[FIRDatabase database] reference];   // Set Firebase Dababase handle.

    // Call super after setting up the options
    [super viewDidLoad];
    
 /*   [[[_ref child:@"Messages"] child:_messageID]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        NSLog(@"%@",postDict);
        for(int i=0;i<postDict.count;i++)
        {
            NSString * key = postDict.allKeys[i];
            NSString *date = [key substringFromIndex:28];
            key = [key substringToIndex:28];
            if([key isEqualToString:[FIRAuth auth].currentUser.uid])
            {
                NSString *text = [postDict objectForKey:postDict.allKeys[i]];
                [self.data addObject:@{ @"text": text,
                                        @"date": [NSDate date],
                                        @"type": @(AMBubbleCellSent),
                                        @"username": @"Stevie",
                                        @"color": [UIColor redColor]
                                        }];
            }
            else{
                NSString *text = [postDict objectForKey:postDict.allKeys[i]];
                [self.data addObject:@{ @"text": text,
                                        @"date": [NSDate date],
                                        @"type": @(AMBubbleCellReceived),
                                        @"username": @"Stevie",
                                        @"color": [UIColor redColor]
                                        }];
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.data.count - 1) inSection:0];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
        }
    }];*/
    
    [[[_ref child:@"Messages"] child:_messageID]  observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        [self.data removeAllObjects];
       NSLog(@"%@",postDict);
        if(postDict != [NSNull null])
        {
        sortedKeys1 = [[postDict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
        
        
/*        for(int i=0;i<sortedKeys1.count;i++)
        {
            [dictSorted setObject:[postDict objectForKey:sortedKeys1[i]] forKey:sortedKeys1[i]];
 //           [arrayOftexts addObject:[postDict objectForKey:sortedKeys1[i]]];
        }*/
        
        
        for(int i=0;i<sortedKeys1.count;i++)
        {
            NSString * key = sortedKeys1[i];
            NSString *dateString = [key substringToIndex:14];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyyyMMddHHmmss";
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-07:00"]];
            
            NSDate *date = [dateFormatter dateFromString:dateString];

            
            
            key = [key substringFromIndex:14];
            if([key isEqualToString:[FIRAuth auth].currentUser.uid])
            {
                NSString *text =[postDict objectForKey:sortedKeys1[i]];;
                [self.data addObject:@{ @"text": text,
                                        @"date": date,
                                        @"type": @(AMBubbleCellSent),
                                        @"username": @"Stevie",
                                        @"color": [UIColor redColor],
                                        }];
            }
            else{
                NSString *text =[postDict objectForKey:sortedKeys1[i]];;
                [self.data addObject:@{ @"text": text,
                                        @"date": date,
                                        @"type": @(AMBubbleCellReceived),
                                        @"username": _nameOfSender,
                                        @"color": [UIColor redColor],
                                        }];
            }
          /*  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.data.count - 1) inSection:0];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];*/
//            [self scrollToBottomAnimated:YES];

             [super reloadTableScrollingToBottom:YES];

        }
        }
    }];
    [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*- (NSMutableArray *)messages
{
    //return array of id<SOMessage> objects
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    id<SOMessage *> message = self.dataSource[index];
    
    // Customize balloon as you wish
    if (message.fromMe) {
        
    } else {
        
    }
}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SOMessaging delegate
- (void)fakeMessages
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self didSendText:@"Fake message here!"];
        [self fakeMessages];
    });
}

- (void)swipedCellAtIndexPath:(NSIndexPath *)indexPath withFrame:(CGRect)frame andDirection:(UISwipeGestureRecognizerDirection)direction
{
    NSLog(@"swiped");
}

#pragma mark - AMBubbleTableDataSource

- (NSInteger)numberOfRows
{
    return self.data.count;
}

- (AMBubbleCellType)cellTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.data[indexPath.row][@"type"] intValue];
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row][@"text"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return self.data[indexPath.row][@"date"];
}

- (UIImage*)avatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.data[indexPath.row] objectForKey:@"type"]intValue] == 1)
        return myProfileImage;
    else
        return _senderImage;
    return _senderImage;
}

#pragma mark - AMBubbleTableDelegate

- (void)didSendText:(NSString*)text
{
    NSLog(@"User wrote: %@", text);
    
    [self.data addObject:@{ @"text": text,
                            @"date": [NSDate date],
                            @"username": @"Kenny",
                            @"color": [UIColor redColor],
                            @"type": @(AMBubbleCellSent)
                            }];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-07:00"]];
    NSDate * timeNow = [NSDate date];
    
    NSString *stringTime = [dateFormatter stringFromDate:timeNow];
    NSString *keyOfSend = [stringTime stringByAppendingString:[FIRAuth auth].currentUser.uid];
    [[[[_ref child:@"Messages"] child:_messageID] child:keyOfSend]
     setValue:text];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.data.count - 1) inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    // Either do this:
    [self scrollToBottomAnimated:YES];
    // or this:
    // [super reloadTableScrollingToBottom:YES];
}

- (NSString*)usernameForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row][@"username"];
}

- (UIColor*)usernameColorForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row][@"color"];
}


- (IBAction)onBack:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
@end
