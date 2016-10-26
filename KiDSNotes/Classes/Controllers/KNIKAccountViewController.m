//
//  KNIKAccountViewController.m
//  KiDSNotes
//
//  Created by deus4 on 25/04/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "KNIKAccountViewController.h"
#import "IKAccountSectionHeaderView.h"
#import "ChatView.h"
#import "recent.h"
#import "IKAccountViewController.h"
@interface KNIKAccountViewController () <UITableViewDelegate, IKPhotoHeaderViewDelegate, IKPhotoCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *userDisplayNameLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSMutableArray *childrenArray;
@property (strong, nonatomic) IBOutlet PFImageView *firstChildrenImageView;
@property (strong, nonatomic) IBOutlet PFImageView *secondChildrenImageView;
@property (strong, nonatomic) IBOutlet PFImageView *thirdChildrenImageView;
@property (strong, nonatomic) IBOutlet PFImageView *forthChildrenImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstChildrenLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondChildrenLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdChildrenLabel;
@property (strong, nonatomic) IBOutlet UILabel *forthChildrenLabel;
@property (strong, nonatomic) IBOutlet UIView *firstChildrenView;
@property (strong, nonatomic) IBOutlet UIView *secondChildrenView;
@property (strong, nonatomic) IBOutlet UIView *thirdChildrenView;
@property (strong, nonatomic) IBOutlet UIView *forthChildrenView;
@property (strong, nonatomic) IBOutlet UIStackView *childrenStackView;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIButton *friendButton;
@property (strong, nonatomic) IBOutlet UIButton *profileSettingsButton;
@property (strong, nonatomic) IBOutlet UIButton *profileChangePhotoButton;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;
@property (strong, nonatomic) IBOutlet UILabel *profileCityLabel;


@end

@implementation KNIKAccountViewController
@synthesize outstandingSectionHeaderQueries;

@synthesize headerView;
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.user) {
        self.user = [PFUser currentUser];
        //[[PFUser currentUser] fetchIfNeeded];
    }
    self.firstChildrenImageView.layer.cornerRadius = 25.0f;
    self.secondChildrenImageView.layer.cornerRadius = 25.0f;
    self.thirdChildrenImageView.layer.cornerRadius = 25.0f;
    self.forthChildrenImageView.layer.cornerRadius = 25.0f;
    self.profilePictureImageView.layer.cornerRadius = 45.0f;
    self.profilePictureImageView.layer.masksToBounds = YES;
    self.profilePictureImageView.alpha = 1.0f;
    self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
    
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
    } else {
        
        self.profilePictureImageView.image = [PAPUtility defaultProfilePicture];
        [UIView animateWithDuration:0.2f animations:^{
            self.profilePictureImageView.alpha = 1.0f;
        }];
    }
    
    NSString *text = [self.user objectForKey:@"displayName"];
    [self.userDisplayNameLabel setText:[text uppercaseString]];
    [self.profileCityLabel setText:[self.user valueForKey:@"city"]];
    PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
    [queryPhotoCount whereKey:kPAPPhotoUserKey equalTo:self.user];
    [queryPhotoCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.photoCountLabel setText:[NSString stringWithFormat:@"%d%@", number, number==1?@"":@""]];
            [[PAPCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:self.user];
        }
    }];
    PFQuery *queryFollowerCount = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryFollowerCount whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [queryFollowerCount whereKey:kPAPActivityToUserKey equalTo:self.user];
    [queryFollowerCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowerCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.followerCountLabel setText:[NSString stringWithFormat:@"%d%@", number, number==1?@"":@""]];
        }
    }];
    
    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryFollowingCount whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [queryFollowingCount whereKey:kPAPActivityFromUserKey equalTo:self.user];
    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.followingCountLabel setText:[NSString stringWithFormat:@"%d", number]];
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
                    //[self configureFollowButton];
                } else {
                    //[self configureUnfollowButton];
                }
            }
        }];
    }
    self.childrenArray = [[NSMutableArray alloc]init];
    
    
    [self loadObjects];
    [self checkCurrentUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadChidldrens];
}
- (void)checkCurrentUser {
    PFUser *currentUser = [PFUser currentUser];
    NSString *test1 = [currentUser objectId];
    NSString *test2 = [self.user objectId];
    
    if ([test1 isEqualToString:test2]) {
        self.messageButton.hidden = true;
        self.friendButton.hidden = true;
    } else {
        self.profileSettingsButton.hidden = true;
        self.profileChangePhotoButton.hidden = true;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    } else {
        
        self.profilePictureImageView.image = [PAPUtility defaultProfilePicture];
        [UIView animateWithDuration:0.2f animations:^{
            self.profilePictureImageView.alpha = 1.0f;
        }];
    }
    
    NSString *text = [self.user objectForKey:@"displayName"];
    [self.userDisplayNameLabel setText:[text uppercaseString]];
    
    PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
    [queryPhotoCount whereKey:kPAPPhotoUserKey equalTo:self.user];
    [queryPhotoCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.photoCountLabel setText:[NSString stringWithFormat:@"%d%@", number, number==1?@"":@""]];
            [[PAPCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:self.user];
        }
    }];
    PFQuery *queryFollowerCount = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryFollowerCount whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [queryFollowerCount whereKey:kPAPActivityToUserKey equalTo:self.user];
    [queryFollowerCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowerCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.followerCountLabel setText:[NSString stringWithFormat:@"%d%@", number, number==1?@"":@""]];
        }
    }];
    
    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryFollowingCount whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [queryFollowingCount whereKey:kPAPActivityFromUserKey equalTo:self.user];
    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.followingCountLabel setText:[NSString stringWithFormat:@"%d", number]];
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
                    //[self configureFollowButton];
                } else {
                    //[self configureUnfollowButton];
                }
            }
        }];
    }
}
#pragma mark - PFQueryTableViewController
- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
}

- (void)loadChidldrens {
    PFQuery *query = [PFQuery queryWithClassName:@"Children"];
    [query whereKey:@"Parent" equalTo:self.user];
    [query includeKey:@"user"];
    //self.childrenArray = [NSMutableArray arrayWithArray:[query findObjects]];
    self.childrenArray = [NSMutableArray arrayWithArray:[query findObjects]];
    PFObject *childrenObject = [[PFObject alloc]initWithClassName:@"Children"];
    
    if ([self.childrenArray count]==0) {
        NSLog(@"Empty");
        self.childrenStackView.hidden = YES;
        
    }   else    {
        if ([self.childrenArray count] > 0) {
            if ([self.childrenArray objectAtIndex:0]) {
                self.firstChildrenView.hidden = NO;
                childrenObject = [self.childrenArray objectAtIndex:0];
                self.firstChildrenImageView.file = [childrenObject objectForKey:@"photo"];
                [self.firstChildrenImageView loadInBackground];
                self.firstChildrenLabel.text = [childrenObject objectForKey:@"name"];
            }
        }
        if ([self.childrenArray count] > 1) {
            if ([self.childrenArray objectAtIndex:1]) {
                self.secondChildrenView.hidden = NO;
                childrenObject = [self.childrenArray objectAtIndex:1];
                self.secondChildrenImageView.file = [childrenObject objectForKey:@"photo"];
                [self.secondChildrenImageView loadInBackground];
                self.secondChildrenLabel.text = [childrenObject objectForKey:@"name"];
            }
        }
        if ([self.childrenArray count] > 2) {
            self.thirdChildrenView.hidden = NO;
            if ([self.childrenArray objectAtIndex:2]) {
                childrenObject = [self.childrenArray objectAtIndex:2];
                self.thirdChildrenImageView.file = [childrenObject objectForKey:@"photo"];
                [self.thirdChildrenImageView loadInBackground];
                self.thirdChildrenLabel.text = [childrenObject objectForKey:@"name"];
            }
        }
        if ([self.childrenArray count] > 3) {
            self.forthChildrenView.hidden = NO;
            if ([self.childrenArray objectAtIndex:3] != nil) {
                childrenObject = [self.childrenArray objectAtIndex:3];
                self.forthChildrenImageView.file = [childrenObject objectForKey:@"photo"];
                [self.forthChildrenImageView loadInBackground];
                self.forthChildrenLabel.text = [childrenObject objectForKey:@"name"];
            }
        }
    }
}
- (PFQuery *)queryForTable {
    if (!self.user) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query whereKey:kPAPPhotoUserKey equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    [query includeKey:kPAPPhotoUserKey];
    return query;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellIdentifier = @"CellPhoto";
    static NSString *cellIdent = @"Cell";
    
    
    if (indexPath.row % 2 == 0) {
        //Photo likes comments
        IKPhotoCell *cell = (IKPhotoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (object) {
            cell.photoImage.file = [object objectForKey:@"image"];
            cell.delegate = self;
            if ([cell.photoImage.file isDataAvailable]) {
                [cell.photoImage loadInBackground];
            }
        }
        [cell.photoImage loadInBackground];
        
        return cell;
        //return [self detailPhotoCellForRowAtIndexPath:indexPath];
    } else {
        IKPhotoHeaderView *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdent];
        //  [cell.likeLabel setText:[[[PAPCache sharedCache]likeCountForPhoto:object]description]];
        //   [cell.commentsLabel setText:[[[PAPCache sharedCache] commentCountForPhoto:object]description]];
        [cell.commentLabel setText:[object valueForKey:@"photoComment"]];
        cell.delegate = self;
        
        NSDictionary *attributesForPhoto = [[PAPCache sharedCache] attributesForPhoto:object];
        if (attributesForPhoto) {
            [cell setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:object]];
            [cell.likeLabel setText:[[[PAPCache sharedCache]likeCountForPhoto:object]description]];
            [cell.commentsLabel setText:[[[PAPCache sharedCache] commentCountForPhoto:object]description]];
            if (cell.likeButton.alpha < 1.0f || cell.commentButton.alpha < 1.0f) {
                [UIView animateWithDuration:0.200f animations:^{
                    cell.likeButton.alpha = 1.0f;
                    cell.commentButton.alpha = 1.0f;
                    cell.likeLabel.alpha = 1.0f;
                    cell.commentsLabel.alpha = 1.0f;
                }];
            }
        }   else    {
            cell.likeButton.alpha = 0.0f;
            cell.likeLabel.alpha = 0.0f;
            cell.commentsLabel.alpha = 0.0f;
            cell.commentButton.alpha = 0.0f;
            
            @synchronized(self) {
                NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:@(indexPath.row)];
                if (!outstandingSectionHeaderQueryStatus) {
                    PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:object cachePolicy:kPFCachePolicyNetworkOnly];
                    
                    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                        @synchronized(self) {
                            [self.outstandingSectionHeaderQueries removeObjectForKey:@(indexPath.row)];
                            
                            if (error) {
                                return;
                            }
                            
                            NSMutableArray *likers = [NSMutableArray array];
                            NSMutableArray *commenters = [NSMutableArray array];
                            
                            BOOL isLikedByCurrentUser = NO;
                            
                            for (PFObject *activity in objects) {
                                if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike] && [activity objectForKey:kPAPActivityFromUserKey]) {
                                    [likers addObject:[activity objectForKey:kPAPActivityFromUserKey]];
                                } else if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeComment] && [activity objectForKey:kPAPActivityFromUserKey]) {
                                    [commenters addObject:[activity objectForKey:kPAPActivityFromUserKey]];
                                }
                                if ([[[activity objectForKey:kPAPActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                    if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike]) {
                                        isLikedByCurrentUser = YES;
                                    }
                                }
                            }
                            [[PAPCache sharedCache] setAttributesForPhoto:object likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                            if (cell.tag != index) {
                                return;
                            }
                            [cell setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:object]];
                            [cell.likeButton setTitle:[[[PAPCache sharedCache] likeCountForPhoto:object] description] forState:UIControlStateNormal];
                            [cell.commentButton setTitle:[[[PAPCache sharedCache] commentCountForPhoto:object] description] forState:UIControlStateNormal];
                            if (cell.likeButton.alpha < 1.0f || cell.commentButton.alpha < 1.0f) {
                                [UIView animateWithDuration:0.200f animations:^{
                                    cell.likeButton.alpha = 1.0f;
                                    cell.commentButton.alpha = 1.0f;
                                    cell.commentLabel.alpha = 1.0f;
                                    cell.likeLabel.alpha = 1.0f;
                                }];
                            }
                        }
                    }];
                }
            }
        }
        return cell;
    }
}
#pragma mark - Cell's delegation
- (UITableViewCell *)detailPhotoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdent = @"Cell";
    IKPhotoHeaderView *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdent];
    return cell;
}
#pragma mark - Action's
- (IBAction)startPrivatChatWithUser:(UIButton *)sender {
    [self didSelectSingleUser:self.user];
}
- (IBAction)changeProfileAction:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Сменить фотографию профиля"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Фотография с камеры" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                                                              picker.delegate = self;
                                                              picker.allowsEditing = YES;
                                                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              [self presentViewController:picker animated:YES completion:NULL];
                                                          }];
    UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"Фотография с фотоальбома" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                               picker.delegate = self;
                                                               picker.allowsEditing = YES;
                                                               picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                               
                                                               [self presentViewController:picker animated:YES completion:NULL];
                                                           }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [alert addAction:defaultAction2];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1.0f);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"profilePictureMedium"] = imageFile;
    currentUser[@"profilePictureSmall"] = imageFile;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.profilePictureImageView.image = chosenImage;
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    
    self.profilePictureImageView.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didSelectSingleUser:(PFUser *)user2 {
    PFUser *user1 = [PFUser currentUser];
    NSString *groupId = StartPrivateChat(user1, user2);
    [self actionChat:groupId];
}

- (void)actionChat:(NSString *)groupId  {
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.title = [self.user valueForKey:@"displayName"];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}
@end
