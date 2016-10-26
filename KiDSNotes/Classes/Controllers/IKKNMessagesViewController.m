//
//  IKKNMessagesViewController.m
//  KiDSNotes
//
//  Created by deus4 on 30/06/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNMessagesViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import <Parse/Parse.h>
#import "RecentCell.h"
#import "ChatView.h"

@interface IKKNMessagesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *recents;
@property (strong, nonatomic) NSString *selectedUserString;
@end

@implementation IKKNMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recents = [NSMutableArray array];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadRecents];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadRecents {
    PFQuery *query = [PFQuery queryWithClassName:@"Recent"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"lastUser"];
    [query orderByDescending:@"updatedAction"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error) {
            [self.recents removeAllObjects];
            [self.recents addObjectsFromArray:objects];
            
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);

        }
    }];
}
#pragma mark - TableView 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recents count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    RecentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentCell" forIndexPath:indexPath];
    [cell bindData:self.recents[indexPath.row]];
    return cell;
}
#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFObject *recent = self.recents[indexPath.row];
    self.selectedUserString = recent[@"description"];
    [self actionChat:recent[@"groupId"]];
}
- (void)actionChat:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    chatView.title = self.selectedUserString;
    [self.navigationController pushViewController:chatView animated:YES];
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
