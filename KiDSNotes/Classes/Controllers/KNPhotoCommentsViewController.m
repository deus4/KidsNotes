//
//  KNPhotoCommentsViewController.m
//  KiDSNotes
//
//  Created by deus4 on 11/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNPhotoCommentsViewController.h"
#import "Parse.h"
#import "PAPConstants.h"
#import "PAPUtility.h"

#import "TTTTimeIntervalFormatter.h"

@interface KNPhotoCommentsViewController () <UITableViewDelegate>
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@end

@implementation KNPhotoCommentsViewController

static NSString *cellIdentifier = @"CommentCell";

@synthesize photo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureTableView];
}

#pragma mark - TableView
- (void)configureTableView {
    self.tableView.estimatedRowHeight = 160.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - PFQueryTableViewController
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = kPAPActivityClassKey;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 50;
        if (!self.timeIntervalFormatter) {
            self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
            [self.timeIntervalFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ru"]];
        }
    }
    return self;
}

- (PFQuery *)queryForTable  {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kPAPActivityPhotoKey equalTo:self.photo];
    [query includeKey:kPAPActivityFromUserKey];
    [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeComment];
    [query orderByAscending:@"createdAt"];
    
    return query;
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object   {
       KNPhotoCommentCell *cell = (KNPhotoCommentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[KNPhotoCommentCell alloc] init];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(KNPhotoCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath   {
    PFObject *item = [self objectAtIndexPath:indexPath];
    PFObject *user = item[@"fromUser"];
    [self setUserDetailCell:cell user:user];
    [self setUserCommentCell:cell item:item];
}
- (void)setUserDetailCell:(KNPhotoCommentCell *)cell user:(PFObject *)user {
    NSString *firstName = user[@"firstName"];
    NSString *lastName = user[@"lastName"];
    NSString *qandaString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
  //   cell.userProfilePicture.image = [UIImage imageNamed:@"profileBearPicture"];

    // Set your placeholder image first
    cell.userProfilePicture.image = [UIImage imageNamed:@"profileBearPicture"];
    PFFile *imageFile = [user objectForKey:@"profilePicture"];
    if (imageFile != NULL) {
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            // Now that the data is fetched, update the cell's image property.
            [cell.userProfilePicture setFile:imageFile];
        }];
    }
    cell.userProfilePicture.layer.cornerRadius = 18;

    cell.userNameLabel.text = qandaString;
}
- (void)setUserCommentCell:(KNPhotoCommentCell *)cell item:(PFObject *)item  {
    NSString *userComment = item[@"content"];

    cell.commentLabel.text = userComment;
    [cell.timeStampLabel setText:[self.timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[item createdAt]]];
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
