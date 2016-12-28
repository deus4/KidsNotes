//
//  IKFeedlineTableViewController.m
//  KiDSNotes
//
//  Created by deus4 on 03/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKFeedlineTableViewController.h"
#import "IKFeedlineTableViewCell.h"
#import "IKPhotoCell.h"
#import "IKPhotoHeaderView.h"
#import "AppDelegate.h"
#import "IKAccountViewController.h"
#import "IKFeedlineViewController.h"
#import "IKAccountCollectionViewController.h"
#import "KNIKAccountViewController.h"
#import "IKKNPhotoDetailsViewController.h"
#import "IKKNPhotoMainViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "ProgressHUD.h"

@interface IKFeedlineTableViewController ()

@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;
@property (nonatomic, strong) IKFeedlineViewController *feedController;

@end

@implementation IKFeedlineTableViewController
@synthesize reusableSectionHeaderViews;
@synthesize shouldReloadOnAppear;
@synthesize outstandingSectionHeaderQueries;
@synthesize numberOfPages;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        // The className to query on
        self.parseClassName = kPAPPhotoClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = YES;
        
        self.shouldReloadOnAppear = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 350.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self loadObjects];
    
    
}
- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    self.numberOfPages = [self.objects count];
    if (![self isKindOfClass:[KNIKAccountViewController class]]) {
        IKFeedlineViewController *feedLineController = (IKFeedlineViewController *)self.parentViewController;
        if (self.numberOfPages > 0) {
            feedLineController.blankTimelineView.hidden = YES;
        } else {
            feedLineController.blankTimelineView.hidden = YES;
        }
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count * 2 + (self.paginationEnabled ? 1 : 0);
}
#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![self objectAtIndexPath:indexPath]) {
        // Load More Cell
        [self loadNextPage];
    }
}
#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    // Query for the friends the current user is following
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kPAPActivityClassKey];
    
    if (self.numberOfPages > 0) { //If true, return records only from friends, if false - from all others.
        [followingActivitiesQuery whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
        [followingActivitiesQuery whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
    }
    
    followingActivitiesQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    followingActivitiesQuery.limit = 1000;
    
    PFQuery *autoFollowUsersQuery = [PFUser query];
    [autoFollowUsersQuery whereKey:kPAPUserAutoFollowKey equalTo:@YES];
    // Using the activities from the query above, we find all of the photos taken by
    // the friends the current user is following
    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromFollowedUsersQuery whereKey:kPAPPhotoUserKey matchesKey:kPAPActivityToUserKey inQuery:followingActivitiesQuery];
    [photosFromFollowedUsersQuery whereKeyExists:kPAPPhotoPictureKey];
    
    // We create a second query for the current user's photos
    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromCurrentUserQuery whereKey:kPAPPhotoUserKey equalTo:[PFUser currentUser]];
    [photosFromCurrentUserQuery whereKeyExists:kPAPPhotoPictureKey];
    
    // We create a final compound query that will find all of the photos that were
    // taken by the user's friends or by the user
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromFollowedUsersQuery, photosFromCurrentUserQuery, nil]];
    [query includeKey:kPAPPhotoUserKey];
    [query orderByDescending:@"createdAt"];
    
    // A pull-to-refresh should always trigger a network request.
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    /*
     This query will result in an error if the schema hasn't been set beforehand. While Parse usually handles this automatically, this is not the case for a compound query such as this one. The error thrown is:
     
     Error: bad special key: __type
     
     To set up your schema, you may post a photo with a caption. This will automatically set up the Photo and Activity classes needed by this query.
     
     You may also use the Data Browser at Parse.com to set up your classes in the following manner.
     
     Create a User class: "User" (if it does not exist)
     
     Create a Custom class: "Activity"
     - Add a column of type pointer to "User", named "fromUser"
     - Add a column of type pointer to "User", named "toUser"
     - Add a string column "type"
     
     Create a Custom class: "Photo"
     - Add a column of type pointer to "User", named "user"
     
     You'll notice that these correspond to each of the fields used by the preceding query.
     */
    
    
    return query;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];
    if (index < self.objects.count) {
        return self.objects[index];
    }
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellIdentifier = @"CellPhoto";
    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cella"];
    if ([self isKindOfClass:[IKFeedlineTableViewController class]]) {
        if (indexPath.row % 2 == 0) {
            // Header
            return [self detailPhotoCellForRowAtIndexPath:indexPath];
        }
    }
    if ([self isKindOfClass:[IKFeedlineTableViewController class]]) {
        // Photo
        IKPhotoCell *cell = (IKPhotoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cell.photoButton addTarget:self action:@selector(didTapOnPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate = self;
        // cell = [[IKPhotoCell alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 55.0f) buttons:IKPhotoCellButtonsDefault];
        PFObject *photoUserOwner = [object objectForKey:@"user"];
        PFUser *currnetUser = [PFUser currentUser];
        cell.buttons = IKPhotoCellButtonsDefault;
        cell.photo = object;
        cell.photoButton.tag = index;
        [cell.likeButton setTag:index];
        cell.settingsButton.hidden = true;
        if ([[photoUserOwner objectId] isEqualToString:[currnetUser objectId]]) {
            cell.settingsButton.hidden = false;
            
        }
        NSDictionary *attributesForPhoto = [[PAPCache sharedCache] attributesForPhoto:object];
        if (attributesForPhoto) {
            [cell setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:object]];
            [cell.likeLabel setText:[[[PAPCache sharedCache]likeCountForPhoto:object]description]];
            [cell.commentLabel setText:[[[PAPCache sharedCache] commentCountForPhoto:object]description]];
            if (cell.likeButton.alpha < 1.0f || cell.commentButton.alpha < 1.0f) {
                [UIView animateWithDuration:0.200f animations:^{
                    cell.likeButton.alpha = 1.0f;
                    cell.commentButton.alpha = 1.0f;
                    cell.likeLabel.alpha = 1.0f;
                    cell.commentLabel.alpha = 1.0f;
                }];
            }
        }   else    {
            cell.likeButton.alpha = 0.0f;
            cell.likeLabel.alpha = 0.0f;
            cell.commentLabel.alpha = 0.0f;
            cell.commentButton.alpha = 0.0f;
            
            @synchronized(self) {
                NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:@(index)];
                if (!outstandingSectionHeaderQueryStatus) {
                    PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:object cachePolicy:kPFCachePolicyNetworkOnly];
                    
                    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                        @synchronized(self) {
                            [self.outstandingSectionHeaderQueries removeObjectForKey:@(index)];
                            
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
        
        
        cell.photoImage.image = [UIImage imageNamed:@"placholderPhotoPDF"];
        cell.commentTextLabel.text = [object objectForKey:@"photoComment"];
        if (object) {
            cell.photoImage.file = [object objectForKey:@"image"];
            
            if ([cell.photoImage.file isDataAvailable]) {
                [cell.photoImage loadInBackground];
            }
        }
        [cell.photoImage loadInBackground];
        return cell;
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        // cell.hideSeparatorBottom = YES;
        // cell.mainView.backgroundColor = [UIColor clearColor];
    }
    [cell.textLabel setText:@"load more"];
    return cell;
}

#pragma mark - IKPhotoViewController

- (IKPhotoHeaderView *)dequeueReusableSectionHeaderView {
    for (IKPhotoHeaderView *sectionHeaderView in self.reusableSectionHeaderViews) {
        if (!sectionHeaderView.superview) {
            return sectionHeaderView;
        }
    }
    return nil;
}
- (void)photoHeaderView:(IKPhotoHeaderView *)photoHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user    {
    if ([self isKindOfClass:[IKAccountViewController class]]) {
        CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
        anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
        anim.autoreverses = YES ;
        anim.repeatCount = 2.0f ;
        anim.duration = 0.07f ;
        [self.view.layer addAnimation:anim forKey:nil];
    }   else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
        KNIKAccountViewController *accountViewController = [storyboard instantiateViewControllerWithIdentifier:@"feedView"];
        [accountViewController setUser:user];
        [self.navigationController pushViewController:accountViewController animated:YES];
    }
}
- (void)photoHeaderView:(IKPhotoCell *)photoHeaderView didTapLikePhotoButton:(UIButton *)button photo:(PFObject *)photo   {
    [photoHeaderView shouldEnableLikeButton:NO];
    BOOL liked = !button.selected;
    [photoHeaderView setLikeStatus:liked];
    NSString *originalButtonTitle = button.titleLabel.text;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSNumber *likeCount = [numberFormatter numberFromString:photoHeaderView.likeLabel.text];
    if (liked) {
        likeCount = [NSNumber numberWithInt:[likeCount intValue] + 1];
        [[PAPCache sharedCache] incrementLikerCountForPhoto:photo];
    } else {
        if ([likeCount intValue] > 0) {
            likeCount = [NSNumber numberWithInt:[likeCount intValue] - 1];
        }
        [[PAPCache sharedCache] decrementLikerCountForPhoto:photo];
    }
    [[PAPCache sharedCache] setPhotoIsLikedByCurrentUser:photo liked:liked];
    [photoHeaderView.likeLabel setText:[numberFormatter stringFromNumber:likeCount]];
    if (liked) {
        [PAPUtility likePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
            IKPhotoHeaderView *actualHeaderView = (IKPhotoHeaderView *)[self tableView:self.tableView viewForHeaderInSection:button.tag];
            [actualHeaderView shouldEnableLikeButton:YES];
            [actualHeaderView setLikeStatus:succeeded];
            
            if (!succeeded) {
                [actualHeaderView.likeButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
        }];
    }
}
- (void)photoHeaderView:(IKPhotoCell *)photoHeaderView didTapSettingsOnPhotoButton:(UIButton *)button photo:(PFObject *)photo {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * action) {
                                                             [ProgressHUD show:@"Обновляем" Interaction:false];
                                                             [photo deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                                 if (!error) {
                                                                     [ProgressHUD showSuccess:@"Фотография удалена" Interaction:true];
                                                                     [self loadObjects];
                                                                     [self.tableView reloadData];
                                                                 } else {
                                                                      [ProgressHUD showError:@"Произошла ошибка" Interaction:true];
                                                                 }
                                                             }];
                                                         }];
    UIAlertAction* editAction = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {}];
    UIAlertAction* shareAction = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:deleteAction];
    [alert addAction:editAction];
    [alert addAction:shareAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)photoHeaderView:(IKPhotoCell *)photoHeaderView didTapCommentOnPhotoButton:(UIButton *)button photo:(PFObject *)photo  {
    [self performSegueWithIdentifier:@"commentPhoto" sender:photo];
}

#pragma mark ()

- (UITableViewCell *)detailPhotoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdent = @"Cell";
    if (self.paginationEnabled && indexPath.row == self.objects.count *2) {
        return nil;
    }
    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];
    
    IKPhotoHeaderView *headerView = [self.tableView dequeueReusableCellWithIdentifier:cellIdent];
    headerView.delegate = self;
    headerView.selectionStyle = UITableViewCellSelectionStyleNone;
    // headerView initWithCoder:<#(NSCoder *)#> buttons:<#(IKPhotoHeaderButtons)#>
    PFObject *object = [self objectAtIndexPath:indexPath];
    headerView.photo = object;
    headerView.tag = index;
    
    [headerView.likeButton setTag:index];
    
    NSDictionary *attributesForPhoto = [[PAPCache sharedCache] attributesForPhoto:object];
    if (attributesForPhoto) {
        [headerView setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:object]];
        [headerView.likeButton setTitle:[[[PAPCache sharedCache] likeCountForPhoto:object] description] forState:UIControlStateNormal];
        [headerView.commentButton setTitle:[[[PAPCache sharedCache] commentCountForPhoto:object] description] forState:UIControlStateNormal];
        
        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
            [UIView animateWithDuration:0.200f animations:^{
                headerView.likeButton.alpha = 1.0f;
                headerView.commentButton.alpha = 1.0f;
            }];
        }
        
    }   else    {
        headerView.likeButton.alpha = 0.0f;
        headerView.commentButton.alpha = 0.0f;
        
        @synchronized(self) {
            NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:@(index)];
            if (!outstandingSectionHeaderQueryStatus) {
                PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:object cachePolicy:kPFCachePolicyNetworkOnly];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    @synchronized(self) {
                        [self.outstandingSectionHeaderQueries removeObjectForKey:@(index)];
                        
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
                        
                        if (headerView.tag != index) {
                            return;
                        }
                        
                        [headerView setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:object]];
                        [headerView.likeButton setTitle:[[[PAPCache sharedCache] likeCountForPhoto:object] description] forState:UIControlStateNormal];
                        [headerView.commentButton setTitle:[[[PAPCache sharedCache] commentCountForPhoto:object] description] forState:UIControlStateNormal];
                        
                        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
                            [UIView animateWithDuration:0.200f animations:^{
                                headerView.likeButton.alpha = 1.0f;
                                headerView.commentButton.alpha = 1.0f;
                            }];
                        }
                        
                    }
                }];
            }
        }
    }
    
    return headerView;
}

- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject {
    for (int i = 0; i < self.objects.count; i++) {
        PFObject *object = [self.objects objectAtIndex:i];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathForRow:i*2+1 inSection:0];
        }
    }
    
    return nil;
}
- (void)userDidLikeOrUnlikePhoto:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidCommentOnPhoto:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
- (void)userDidDeletePhoto:(NSNotification *)note {
    // refresh timeline after a delay
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self loadObjects];
    });
}

- (void)userDidPublishPhoto:(NSNotification *)note {
    if (self.objects.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self loadObjects];
}

- (void)userFollowingChanged:(NSNotification *)note {
    NSLog(@"User following changed.");
    self.shouldReloadOnAppear = YES;
}
- (void)didTapOnPhotoAction:(UIButton *)sender {
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"commentPhoto"]) {
        
        IKKNPhotoMainViewController *viewController = segue.destinationViewController;
        [viewController setPhoto:sender];
    }
    
}

/*
 For each object in self.objects, we display two cells. If pagination is enabled, there will be an extra cell at the end.
 NSIndexPath     index self.objects
 0 0 HEADER      0
 0 1 PHOTO       0
 0 2 HEADER      1
 0 3 PHOTO       1
 0 4 LOAD MORE
 */

- (NSIndexPath *)indexPathForObjectAtIndex:(NSUInteger)index header:(BOOL)header {
    return [NSIndexPath indexPathForItem:(index * 2 + (header ? 0 : 1)) inSection:0];
}

- (NSUInteger)indexForObjectAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row / 2;
}


@end
