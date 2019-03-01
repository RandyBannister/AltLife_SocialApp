//
//  CategoryViewController.m
//  AltLife
//
//  Created by BradReed on 10/5/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "CategoryViewController.h"
#import "CatTableViewCell.h"
#import "CateListViewController.h"


extern int clickedCategory;

@interface CategoryViewController (){
   
}

@end


@implementation CategoryViewController


int cateCountArray[] = {0,0,0,0,0,0};
id imageArray[] = {@"womenformen1.png",@"menforwomen1.png",@"menformen1.png",@"womenforwomen.png",@"tsFormen.png",@"bdsm.png"};
id nameArray[] = {@"WOMEN FOR MEN",@"MEN FOR WOMEN",@"MEN FOR MEN",@"WOMEN FOR WOMEN",@"TS FOR MEN",@"Fetish BDSM"};

- (void)viewDidLoad {
    [super viewDidLoad];
    for(int i=0;i<6;i++)
        cateCountArray [i] =0;
    // Do any additional setup after loading the view.
    CGRect viewRect = self.view.bounds;
    self.tableView.separatorColor = [UIColor clearColor];
    [_tableView setFrame:CGRectMake(0, 0, viewRect.size.width, viewRect.size.height)];
    [_tableView registerNib:[UINib nibWithNibName:@"CatTableViewCell" bundle:nil] forCellReuseIdentifier:@"CatTableViewCell"];
    self.ref = [[FIRDatabase database] reference];

    [[_ref child:@"Posts"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        // ...
        if(postDict == [NSNull null])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No posts"                                                                       message:@"There are no posts match on your profile." preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actAlert = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                
            }];
            [alert addAction:actAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            for(int i=0;i<postDict.count;i++)
            {
                NSDictionary * dict1 = [postDict objectForKey:postDict.allKeys[i]];
                NSLog(@"%@", dict1);
                
                for(int j=0;j<dict1.allKeys.count;j++)
                {
                    NSArray *cat =[[dict1 objectForKey:dict1.allKeys[j]] objectForKey:@"Category"];
                    for(int k=0;k<cat.count;k++)
                        if([cat[k] intValue]== 1)
                        {
                            cateCountArray[k]++;
                        }
                }
            }
            [_tableView reloadData];
        }
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *tableViewCellName = @"CatTableViewCell";
    CatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellName];
    if(cell == nil)
    {
        cell = [[CatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellName];
    }
    cell.cateImage.image = [UIImage imageNamed:imageArray[indexPath.row]];
    
/*
    UIImageView *backgroundCellImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 230)];
    
    backgroundCellImage.image=[UIImage imageNamed:imageArray[indexPath.row]];*/
    [cell.cateTitile setText:nameArray[indexPath.row]];
    NSString *stringOfCount = [NSString stringWithFormat:@"%ld listings",cateCountArray[indexPath.row]];
    [cell.countOfListing setText:stringOfCount];
//    [cell.contentView addSubview:backgroundCellImage];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    clickedCategory = indexPath.row;
    CateListViewController* apvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CateListViewController"];
    [self.navigationController pushViewController:apvc animated:YES];
    
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
