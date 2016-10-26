//
//  FriendsViewController.m
//  KiDSNotes
//
//  Created by deus4 on 29/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsRequestTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Fonts.h"
#import "SuggestionFriendsTableViewCell.h"
#import "KNFindFriendsViewController.h"

@interface FriendsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *friendsRequestLabel;
@property (strong, nonatomic) IBOutlet UIView *viewForTableView;
@property (strong, nonatomic) KNFindFriendsViewController *findFriendsVC;
//FindFriends

@end

@implementation FriendsViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.findFriendsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindFriends"];
   
    self.findFriendsVC.view.frame = self.viewForTableView.bounds;
    [self.viewForTableView addSubview:self.findFriendsVC.view];
    [self addChildViewController:self.findFriendsVC];
    
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

@end
