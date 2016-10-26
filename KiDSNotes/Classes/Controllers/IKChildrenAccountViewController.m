//
//  IKChildrenAccountViewController.m
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKChildrenAccountViewController.h"
#import "IKChildrenAccountCollectionViewCell.h"
@interface IKChildrenAccountViewController ()

@end

@implementation IKChildrenAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (PFQuery *)queryForTable  {
    PFUser *user = [PFUser currentUser];
    [[PFUser currentUser]fetchIfNeeded];
    if (!user) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"user" equalTo:user];
    [query includeKey:@"user"];
    
    return query;
    
}

@end
