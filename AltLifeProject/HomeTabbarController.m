//
//  HomeTabbarController.m
//  AltLife
//
//  Created by BradReed on 10/16/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "HomeTabbarController.h"

@interface HomeTabbarController ()

@end

extern int ifSignUp;
@implementation HomeTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(ifSignUp == 1)
        self.selectedIndex = 4;

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

@end
