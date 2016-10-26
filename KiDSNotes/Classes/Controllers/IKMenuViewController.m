//
//  IKMenuViewController.m
//  KiDSNotes
//
//  Created by deus4 on 30/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "IKMenuDataSource.h"
#import "KNLoginViewController.h"
#import "IKMenuItem.h"

@interface IKMenuViewController ()

@end

@implementation IKMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 20.0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoutButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
#pragma mark - Properties



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case IK_MENU_ITEM_PROFILE:
            self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountNavigation"];
            break;
        case IK_MENU_ITEM_FEED:
            self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedlineNavigation"];
            break;
        case IK_MENU_ITEM_FRIENDS:
            self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsNavigation"];
            break;
        case IK_MENU_ITEM_MESSAGES:
            self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MessagesNavigation"];
            break;
        case IK_MENU_ITEM_KIDS:
            self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"KidsNavigation"];
            break;
        case IK_MENU_ITEM_SETTINGS:
            self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigation"];
            break;
        default:
            break;
    }
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoutButtonPressed:(id)sender {
    [self logOut];
    [self.slidingViewController resetTopViewAnimated:YES];
    
}
- (void)logOut  {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (!error) {
             [self.slidingViewController.topViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];


}
@end
