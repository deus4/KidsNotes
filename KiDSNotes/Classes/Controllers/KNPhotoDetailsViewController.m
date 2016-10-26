//
//  KNPhotoDetailsViewController.m
//  KiDSNotes
//
//  Created by deus4 on 07/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNPhotoDetailsViewController.h"
#import "Parse.h"
#import "PAPConstants.h"
#import "PAPUtility.h"
#import "KNPhotoDetailsCommentCell.h"
#import "commentsTableViewCell.h"

@interface KNPhotoDetailsViewController () <UITableViewDelegate>
@property (nonatomic, assign) BOOL likersQueryInProgress;

@end

@implementation KNPhotoDetailsViewController

@synthesize photo;

#pragma mark - PFQueryTableViewController
//- (id)initWithPhoto:(PFObject *)aPhoto {
//
//    //
//    self = [super initWithStyle:<#(UITableViewStyle)#>
//    if (self) {
//
//        // The className to query on
//        self.parseClassName = kPAPActivityClassKey;
//        
//        // Whether the built-in pull-to-refresh is enabled
//        self.pullToRefreshEnabled = YES;
//        
//        // Whether the built-in pagination is enabled
//        self.paginationEnabled = YES;
//        
//        // The number of comments to show per page
//      //  self.obcojectsPerPage = 30;
//        
//        self.photo = aPhoto;
//        
//        self.likersQueryInProgress = NO;
//    }
//     [self.tableView registerClass:[KNPhotoDetailsCommentCell class] forCellReuseIdentifier:@"cell"];
//    return self;
//}

-  (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = kPAPActivityClassKey;
       // self.textKey = @"";
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
      //  self.photo = self.photoVC.photo;
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;

        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
   // [self.tableView registerClass:[KNPhotoDetailsCommentCell class] forCellReuseIdentifier:@"cell"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[KNPhotoDetailsCommentCell class] forCellReuseIdentifier:@"CommentCell"];
   
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
   // [self.tableView registerClass:[KNPhotoDetailsCommentCell class] forCellReuseIdentifier:@"cell"];
    
    static NSString *cellIdent = @"CommentCell";

         KNPhotoDetailsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent forIndexPath:indexPath];


        NSLog(@"############Photo Details Object#############%@",object);
            PFObject *userObject = object[@"fromUser"];
        NSLog(@"OBJECT PUSER DETAILS%@",userObject);
        PFFile *userPhoto = userObject[@"profilePictureSmall"];
        [cell.userPhoto setFile:userPhoto];
        [cell.userPhoto loadInBackground];

       // [self configureBasicCell:cell atIndexPath:indexPath];
        NSString *userComment = object[@"content"];
        cell.userComment.text = userComment;
       // cell.textLabel.text = userComment;
        NSLog(@"%@",object);
    cell.textLabel.text = userComment;
    cell.userName.text = @"work plz";
         return cell;
   
}
- (void)configureBasicCell:(KNPhotoDetailsCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PFObject *cellItem = [self objectAtIndexPath:indexPath];
    [self setTitleForCell:cell item:cellItem];
    [self setCommentForCell:cell item:cellItem];
    //FLComments *itemComments = [self.item.comments objectAtIndex:indexPath.row];
    // [self setTitleForCell:cell item:itemComments];
    // [self setSubtitleForCell:cell item:itemComments];
}
- (void)setTitleForCell:(KNPhotoDetailsCommentCell *)cell item:(PFObject *)item {
    PFObject *userWhoPosted = item[@"fromUser"];
    NSString *userName = userWhoPosted[@"lastName"];
    NSString *title = userName ?: NSLocalizedString(@"[Нету Имени]", nil);
    [cell.userName setText:title];
}
- (void)setCommentForCell:(KNPhotoDetailsCommentCell *)cell item:(PFObject *)item {
    NSString *userComment = item[@"content"];
    cell.userComment.text = userComment;
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self objects]count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static KNPhotoDetailsCommentCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 300.0f; // Add 1.0f for the cell separator height
}



- (PFQuery *)queryForTable {
    

    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kPAPActivityPhotoKey equalTo:self.photo];
    [query includeKey:kPAPActivityFromUserKey];
    [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeComment];
    [query orderByAscending:@"createdAt"];
    
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
//    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
//        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
//    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    [self loadLikers];
}

- (void)loadLikers {
    if (self.likersQueryInProgress) {
        return;
    }
    
    self.likersQueryInProgress = YES;
    PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likersQueryInProgress = NO;
        if (error) {
          //  [self.headerView reloadLikeBar];
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
        
        [[PAPCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
 //       [self.headerView reloadLikeBar];
    }];
}
- (BOOL)currentUserOwnsPhoto {
    return [[[self.photo objectForKey:kPAPPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",[self objectAtIndexPath:indexPath]);
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
