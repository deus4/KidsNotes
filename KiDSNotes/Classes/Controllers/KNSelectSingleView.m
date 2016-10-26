//
//  SelectSingleView.m
//  KiDSNotes
//
//  Created by deus4 on 20/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//
#import <Parse/Parse.h>
#import "KNSelectSingleView.h"
#import "PFUser+Util.h"
#import "KNSelectSingleCell.h"
#import "PAPUtility.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface KNSelectSingleView()

@end

@implementation KNSelectSingleView
@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = @"_User";
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 550.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel)];
    [self.navigationItem.leftBarButtonItem setTitle:@"Отмена"];
        [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x9FD7B0)];
        [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
}
- (void)viewDidAppear:(BOOL)animated    {
    [super viewDidAppear:animated];
    [self loadObjects];
    [self.tableView reloadData];
    
}

- (nonnull PFQuery *)queryForTable  {
    PFQuery *query1 = [PFQuery queryWithClassName:@"Blocked"];
    [query1 whereKey:@"user1" equalTo:[PFUser currentUser]];
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"objectId" notEqualTo:[PFUser currentId]];
    [query whereKey:@"objectId" doesNotMatchKey:@"userId2" inQuery:query1];
    [query orderByAscending:@"lastName"];
    [query setLimit:1000];
    return query;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return [self.objects count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    KNSelectSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFUser *user = self.objects[indexPath.row];
    NSString *firstName = user[@"firstName"];
    NSString *lastName = user[@"lastName"];
    NSString *qandaString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    cell.labelUserName.text = qandaString;
    
    if ([PAPUtility userHasProfilePictures:user]) {
        PFFile *profilePictureSmall = [user objectForKey:@"profilePicture"];
        [cell.userImage setFile:profilePictureSmall];
        [cell.userImage loadInBackground];
    } else {
        [cell.userImage setImage:[PAPUtility defaultProfilePicture]];
    }
    PFFile *userPhoto = user[@"profilePicture"];

    [cell.userImage setFile:userPhoto];
    [cell.userImage loadInBackground];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [self dismissViewControllerAnimated:YES completion:^{
        if (delegate != nil) [delegate didSelectSingleUser:self.objects[indexPath.row]];
    }];
}
- (void)actionCancel
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
