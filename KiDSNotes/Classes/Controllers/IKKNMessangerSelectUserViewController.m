//
//  IKKNMessangerSelectUserViewController.m
//  KiDSNotes
//
//  Created by deus4 on 30/06/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNMessangerSelectUserViewController.h"
#import "IKKNSelectUserMessageTableViewCell.h"
#import <Parse/Parse.h>
#import "PFUser+Util.h"
#import "ChatView.h"
#import "recent.h"
#import "UIViewController+ECSlidingViewController.h"
#import "ECSlidingSegue.h"

@interface IKKNMessangerSelectUserViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *selectedUserString;
@end

@implementation IKKNMessangerSelectUserViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userArray = [NSMutableArray array];
    [self findFriends];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IKKNSelectUserMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFObject *user = [self.userArray objectAtIndex:indexPath.row];
    PFFile *userPicture = [user objectForKey:@"profilePictureMedium"];
    cell.userNameLabel.text = [user valueForKey:@"displayName"];
    [cell.userProfileImageView setFile:userPicture];
    [cell.userProfileImageView loadInBackground];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *user = self.userArray[indexPath.row];
    self.selectedUserString = [user valueForKey:@"displayName"];
        [self didSelectSingleUser:self.userArray[indexPath.row]];
    
}
- (void)findFriends {
    PFQuery *query1 = [PFQuery queryWithClassName:@"Blocked"];
    [query1 whereKey:@"user1" equalTo:[PFUser currentUser]];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" notEqualTo:[PFUser currentId]];
    [query whereKey:@"objectId" doesNotMatchKey:@"userId2" inQuery:query1];
    [query orderByAscending:@"displayName"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [self.userArray addObjectsFromArray:objects];
            [self.tableView reloadData];

        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void)didSelectSingleUser:(PFUser *)user2
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user1 = [PFUser currentUser];
    
    NSString *groupId = StartPrivateChat(user1, user2);
    [self actionChat:groupId];
}
- (void)actionChat:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.title = self.selectedUserString;
    chatView.hidesBottomBarWhenPushed = YES;
   // [self.navigationController presentViewController:chatView animated:YES completion:nil];
    //[self.navigationController pushViewController:chatView animated:YES];
    [self.navigationController pushViewController:chatView animated:YES];
    //[self.slidingViewController presentViewController:chatView animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ECSlidingSegue *slidingSegue = (ECSlidingSegue *)segue;
    slidingSegue.skipSettingTopViewController = YES;
}
@end
