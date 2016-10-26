//
//  IKAccountViewController.m
//  KiDSNotes
//
//  Created by deus4 on 09/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKAccountViewController.h"
#import "IKLoadMoreTableViewCell.h"

@interface IKAccountViewController ()
@property (nonatomic,strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet PFImageView *profilePictureImageView;
@property (nonatomic, strong) IBOutlet UILabel *photoCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *followerCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *followingCountLabel;
@end

@implementation IKAccountViewController


#pragma mark - Initialization

- (id)initWithUser:(PFUser *)aUser {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.user = aUser;
        
        if (!aUser) {
            [NSException raise:NSInvalidArgumentException format:@"PAPAccountViewController init exception: user cannot be nil"];
        }
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.user) {
        self.user = [PFUser currentUser];
        [[PFUser currentUser] fetchIfNeeded];
    }
    self.profilePictureImageView.alpha = 0.0f;
    if ([PAPUtility userHasProfilePictures:self.user]) {
        PFFile *imageFile = [self.user objectForKey:@"profilePictureMedium"];
        [self.profilePictureImageView setFile:imageFile];
        [self.profilePictureImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (!error) {
                [UIView animateWithDuration:0.2f animations:^{
                    self.profilePictureImageView.alpha = 1.0f;
                }];
            }
        }];
    }   else {
        self.profilePictureImageView.image = [PAPUtility defaultProfilePicture];
        [UIView animateWithDuration:0.2f animations:^{
            self.profilePictureImageView.alpha = 1.0f;
        }];
    }
    
    
    PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
    [queryPhotoCount whereKey:@"user" equalTo:self.user];
    [queryPhotoCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error) {
            [self.photoCountLabel setText:[NSString stringWithFormat:@"%d photo%@", number, number==1?@"":@"s"]];
            [[PAPCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:self.user];
        }
    }];
    
    PFQuery *queryFollowerCount = [PFQuery queryWithClassName:@"Activity"];
    [queryFollowerCount whereKey:@"type" equalTo:@"follow"];
    [queryFollowerCount whereKey:@"toUser" equalTo:self.user];
    [queryFollowerCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowerCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.followerCountLabel setText:[NSString stringWithFormat:@"%d follower%@", number, number==1?@"":@"s"]];
        }
    }];
    NSDictionary *followingDictionary = [[PFUser currentUser] objectForKey:@"following"];
    [self.followingCountLabel setText:@"0 following"];
    if (followingDictionary) {
        [self.followingCountLabel setText:[NSString stringWithFormat:@"%lu following", (unsigned long)[[followingDictionary allValues] count]]];
    }
    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:@"Activity"];
    [queryFollowingCount whereKey:@"type" equalTo:@"follow"];
    [queryFollowingCount whereKey:@"fromUser" equalTo:self.user];
    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.followingCountLabel setText:[NSString stringWithFormat:@"%d following", number]];
        }
    }];
    if (![[self.user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loadingActivityIndicatorView startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
        
        // check if the currentUser is following this user
        PFQuery *queryIsFollowing = [PFQuery queryWithClassName:kPAPActivityClassKey];
        [queryIsFollowing whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
        [queryIsFollowing whereKey:kPAPActivityToUserKey equalTo:self.user];
        [queryIsFollowing whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
        [queryIsFollowing setCachePolicy:kPFCachePolicyCacheThenNetwork];
        [queryIsFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error && [error code] != kPFErrorCacheMiss) {
                NSLog(@"Couldn't determine follow relationship: %@", error);
                self.navigationItem.rightBarButtonItem = nil;
            } else {
                if (number == 0) {
                   // [self configureFollowButton];
                } else {
                   // [self configureUnfollowButton];
                }
            }
        }];
    }
    [self loadObjects];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    self.tableView.tableHeaderView = self.headerView;
}

- (PFQuery *)queryForTable  {
    if (!self.user) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"user" equalTo:self.user];
    [query includeKey:@"user"];
    
    return query;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *loadMoreCellIdentifier = @"loadMoreCell";
    IKLoadMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loadMoreCellIdentifier];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.hideSeparatorBottom = YES;
    cell.mainView.backgroundColor = [UIColor clearColor];
    if (!cell) {
        cell = [[IKLoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadMoreCellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
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
