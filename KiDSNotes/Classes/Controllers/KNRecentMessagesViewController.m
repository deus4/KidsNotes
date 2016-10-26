//
//  KNRecentMessagesViewController.m
//  KiDSNotes
//
//  Created by deus4 on 19/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "KNRecentMessagesViewController.h"
#import "KNRecentTableViewCell.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "ChatView.h"

@interface KNRecentMessagesViewController ()



@end

@implementation KNRecentMessagesViewController

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = @"Recent";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 550.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
   
}
- (void)viewDidAppear:(BOOL)animated    {
    [super viewDidAppear:animated];
    [self loadObjects];
    [self.tableView reloadData];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (nonnull PFQuery *)queryForTable  {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"lastUser"];
    [query orderByDescending:@"updatedAction"];
    return query;
}

- (void)loadRecents
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"lastUser"];
    [query orderByDescending:@"updatedAction"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [self.tableView reloadData];
         }
         else [ProgressHUD showError:@"Network error."];
         [self.refreshControl endRefreshing];
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  object:(nullable PFObject *)object{
    
    static NSString *cellIdentifier = @"Cell";
    KNRecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        PFUser *user = self.objects[indexPath.row];
    
    PFUser *lastUserObj = user[@"lastUser"];
    PFFile *thumbnail = lastUserObj[@"profilePicture"];
    
    [cell.imageUserPicture setFile:thumbnail];
    [cell.imageUserPicture loadInBackground];

    cell.recent = object;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFObject *recent = self.objects[indexPath.row];
    [self actionChat:recent[@"groupId"]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return [self.objects count];
}
- (void)actionChat:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
 //   chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

@end
