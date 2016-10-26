//
//  KNFeedLineViewController.m
//  KiDSNotes
//
//  Created by deus4 on 02/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNFeedLineViewController.h"
#import "Parse.h"
#import "PAPConstants.h"
#import "KNFeedLineCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "PAPUtility.h"
#import "FLCommentsViewController.h"
#import "KNPhotoCommentViewController.h"
#import "KNPhotoDetailsViewController.h"
#import "AppDelegate.h"
#import "KNAccountDetailsViewController.h"


@interface KNFeedLineViewController ()

@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;
@property (nonatomic, weak) PFObject *selectedPhoto;

@end

@implementation KNFeedLineViewController
@synthesize reusableSectionHeaderViews;
@synthesize shouldReloadOnAppear;
@synthesize outstandingSectionHeaderQueries;

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

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
}

- (void)configureTableView {
    self.tableView.estimatedRowHeight = 550.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



#pragma mark - UITableViewDelegate

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
    [followingActivitiesQuery whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [followingActivitiesQuery whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
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



#pragma mark - UITableViewDelegate



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {

    static NSString *cellIdentifier = @"Cell";
    
    
    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];


    
    KNFeedLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (!cell) {
        cell = [[KNFeedLineCell alloc] init];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.photo = object;
    cell.tag = index;
    [cell.likeButton setTag:index];

    
    NSDictionary *attributesForPhoto = [[PAPCache sharedCache] attributesForPhoto:object];
    
    if (attributesForPhoto) {
        [cell setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:object]];
        [cell.likeNumber setText:[[[PAPCache sharedCache]likeCountForPhoto:object] description]];
       
        [cell.commentNumber setText:[[[PAPCache sharedCache]commentCountForPhoto:object] description]];

        
        if (cell.likeButton.alpha < 1.0f ) {
            [UIView animateWithDuration:0.0 animations:^{
                cell.likeButton.alpha = 1.0f;
                
            }];
        }
    } else {
        cell.likeButton.alpha = 0.0f;
        @synchronized(self) {
            // check if we can update the cache
            NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:@(index)];
            if (!outstandingSectionHeaderQueryStatus) {
                PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:object cachePolicy:kPFCachePolicyNetworkOnly];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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
                        
                        
                        if (cell.likeButton.alpha < 1.0f) {
                            [UIView animateWithDuration:0.200f animations:^{
                                cell.likeButton.alpha = 1.0f;
                                
                            }];
                        }
                    }
                }];
            }
        }
    }
    
    cell.actionButton.tag = index;
    //cell.postPhoto.image = [UIImage imageNamed:@"PlaceholderPhoto.png"];
    
    if (object) {
        cell.postPhoto.file = [object objectForKey:kPAPPhotoPictureKey];
        
        // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
        if ([cell.postPhoto.file isDataAvailable]) {
            [cell.postPhoto loadInBackground];
        }

    }

    return cell;
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [self.objects count];
}
#pragma mark - PAPPhotoTimelineViewController


- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Load more...";
    
    return cell;
}

#pragma mark - Navigation
- (void)photoHeaderView:(KNFeedLineCell *)photoHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user {
    if ([self isKindOfClass:[KNFeedLineCell class]]) {
        CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
        anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
        anim.autoreverses = YES ;
        anim.repeatCount = 2.0f ;
        anim.duration = 0.07f ;
        [self.view.layer addAnimation:anim forKey:nil];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        KNAccountDetailsViewController *accountViewController = [storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
        [accountViewController setUser:user];
        [self.navigationController pushViewController:accountViewController animated:YES];
    }
}

- (void)photoHeaderView:(KNFeedLineCell *)cellView didTapLikePhotoButton:(UIButton *)button photo:(PFObject *)photo {
    [cellView shouldEnableLikeButton:NO];
    BOOL liked = !cellView.likeButton.selected;
    [cellView setLikeStatus:liked];
    
    NSString *originalButtonTitle = cellView.likeNumber.text;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSNumber *likeCount = [numberFormatter numberFromString:cellView.likeNumber.text];
    
    if (liked) {
        likeCount = [NSNumber numberWithInt:[likeCount intValue] + 1];
        [[PAPCache sharedCache] incrementLikerCountForPhoto:photo];
       // [cellView.likeButton popOutsideWithDuration:0.5];
        //[cellView.likeButton animate];
    } else {
        if ([likeCount intValue] > 0) {
        //    [cellView.likeButton popInsideWithDuration:0.4];
            likeCount = [NSNumber numberWithInt:[likeCount intValue] - 1];
        }
        [[PAPCache sharedCache] decrementLikerCountForPhoto:photo];
    }
    
    
    [[PAPCache sharedCache] setPhotoIsLikedByCurrentUser:photo liked:liked];
    
    [cellView.likeNumber setText:[numberFormatter stringFromNumber:likeCount]];

    if (liked) {
        [PAPUtility likePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
            KNFeedLineCell *actualCellView = (KNFeedLineCell *)[self tableView:self.tableView viewForHeaderInSection:cellView.likeButton.tag];
            
            [actualCellView shouldEnableLikeButton:YES];
            [actualCellView setLikeStatus:succeeded];
            
            if (!succeeded) {
                [actualCellView.likeNumber setText:originalButtonTitle];
            }
        }];
    } else {
        [PAPUtility unlikePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
             KNFeedLineCell *actualCellView = (KNFeedLineCell *)[self tableView:self.tableView viewForHeaderInSection:cellView.likeButton.tag];
            [actualCellView shouldEnableLikeButton:YES];
            [actualCellView setLikeStatus:!succeeded];
            
            if (!succeeded) {
                [actualCellView.likeNumber setText:originalButtonTitle];
            }
        }];
    }
    
}

- (IBAction)didTapOnPhotoAction:(UIButton *)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    PFObject *photo = [self objectAtIndexPath:indexPath];
    //sender from self to nil
    if (photo) {
        
          self.selectedPhoto = photo;
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"MasterDetail"])
    {
        // Get reference to the destination view controller
        KNPhotoDetailsViewController *vc = segue.destinationViewController;
        vc.photo = self.selectedPhoto;

    }
}
- (NSUInteger)indexForObjectAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row / 2;
}

@end
