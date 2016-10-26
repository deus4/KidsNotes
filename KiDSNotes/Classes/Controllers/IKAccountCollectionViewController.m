//
//  IKAccountCollectionViewController.m
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKAccountCollectionViewController.h"
#import "IKAccountHeaderCollectionReusableView.h"
#import "IKAccountPhotoFeedCollectionViewCell.h"
#import "ProgressHUD.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface IKAccountCollectionViewController () <UICollectionViewDelegate>
@property (nonatomic,strong) IKAccountHeaderCollectionReusableView *headerReusView;
@property (nonatomic, strong) NSMutableArray *childrenArray;
@end

@implementation IKAccountCollectionViewController

#pragma mark - Initialization 


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:UIColorFromRGB(0x009FE8),
       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:20]}];
    if (!self.user) {
        self.user = [PFUser currentUser];
        //     [[PFUser currentUser] fetchIfNeeded];
    }
    self.childrenArray = [[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Children"];
    [query whereKey:@"Parent" equalTo:self.user];
    [query includeKey:@"user"];
    //self.childrenArray = [NSMutableArray arrayWithArray:[query findObjects]];
    self.childrenArray = [NSMutableArray arrayWithArray:[query findObjects]];
    /*
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            
            [self.childrenArray arrayByAddingObjectsFromArray:objects];
         //   [self.collectionView reloadData];
        }
    }];
     */
    [self loadObjects];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated    {
    [super viewDidAppear:animated];
    
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


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    IKAccountHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"accountHeaderView" forIndexPath:indexPath];
    
    headerView.userNameLabel.text = [[self.user objectForKey:@"displayName"]uppercaseString];
    headerView.profileImageView.file = [self.user  objectForKey:@"profilePictureMedium"];
    [headerView.profileImageView loadInBackground];
    
    headerView.cityLabel.text = [self.user objectForKey:@"city"];
    
    
    PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
    [queryPhotoCount whereKey:@"user" equalTo:self.user];
    [queryPhotoCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error) {
            [headerView.publishCountLabel setText:[NSString stringWithFormat:@"%d ", number]];
            [[PAPCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:self.user];
        }
    }];
    
    PFQuery *queryFollowerCount = [PFQuery queryWithClassName:@"Activity"];
    [queryFollowerCount whereKey:@"type" equalTo:@"follow"];
    [queryFollowerCount whereKey:@"toUser" equalTo:self.user];
    [queryFollowerCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowerCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [headerView.subscribersCountLabel setText:[NSString stringWithFormat:@"%d", number]];
        }
    }];
    NSDictionary *followingDictionary = [[PFUser currentUser] objectForKey:@"following"];
    if (followingDictionary) {
        [headerView.subsCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[[followingDictionary allValues] count]]];
    }
    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:@"Activity"];
    [queryFollowingCount whereKey:@"type" equalTo:@"follow"];
    [queryFollowingCount whereKey:@"fromUser" equalTo:self.user];
    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [headerView.subsCountLabel setText:[NSString stringWithFormat:@"%d", number]];
        }
    }];

    PFObject *childrenObject = [[PFObject alloc]initWithClassName:@"Children"];
    
    if ([self.childrenArray count]==0) {
            NSLog(@"Empty");
        
    }   else    {
        
        if ([self.childrenArray objectAtIndex:0]) {
            childrenObject = [self.childrenArray objectAtIndex:0];
            headerView.firstChildImageView.file = [childrenObject objectForKey:@"photo"];
            [headerView.firstChildImageView loadInBackground];
            headerView.firstChildLabel.text = [childrenObject objectForKey:@"name"];
        }
        if ([self.childrenArray objectAtIndex:1]) {
            childrenObject = [self.childrenArray objectAtIndex:1];
            headerView.secondChildImageView.file = [childrenObject objectForKey:@"photo"];
            [headerView.secondChildImageView loadInBackground];
            headerView.secondChildLabel.text = [childrenObject objectForKey:@"name"];
        }
        if ([self.childrenArray objectAtIndex:2]) {
            childrenObject = [self.childrenArray objectAtIndex:2];
            headerView.thirdChildImageView.file = [childrenObject objectForKey:@"photo"];
            [headerView.thirdChildImageView loadInBackground];
            headerView.thirdChildLabel.text = [childrenObject objectForKey:@"name"];
        }
        if ([self.childrenArray objectAtIndex:3]) {
            childrenObject = [self.childrenArray objectAtIndex:3];
            headerView.fourthChildImageView.file = [childrenObject objectForKey:@"photo"];
            [headerView.fourthChildImageView loadInBackground];
            headerView.fourthChildLabel.text = [childrenObject objectForKey:@"name"];
        }

        
    }
  
    

    return headerView;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat dynamicWidht = self.view.frame.size.width * 0.33f;
    return CGSizeMake(dynamicWidht, dynamicWidht);
}
@end
