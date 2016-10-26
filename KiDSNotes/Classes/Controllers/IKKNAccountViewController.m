//
//  IKKNAccountViewController.m
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNAccountViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface IKKNAccountViewController ()

@end

@implementation IKKNAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:UIColorFromRGB(0x009FE8),
       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:20]}];
    
    self.userNameLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0f];
    self.cityLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12.0f];
    
    self.publishCountLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15.0f];
    self.subscribersCountLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15.0f];
    self.subsCountLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15.0f];
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 45.0f;
    PFUser *currentUser = [PFUser currentUser];
    [currentUser fetchInBackground];
    
    self.userNameLabel.text = [[currentUser objectForKey:@"displayName"]uppercaseString];
    self.profileImageView.file = [currentUser objectForKey:@"profilePictureMedium"];
    [self.profileImageView loadInBackground];
    
    self.cityLabel.text = [currentUser objectForKey:@"city"];
    
    
    PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
    [queryPhotoCount whereKey:@"user" equalTo:currentUser];
    [queryPhotoCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error) {
            [self.publishCountLabel setText:[NSString stringWithFormat:@"%d ", number]];
            [[PAPCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:currentUser];
        }
    }];
    
    PFQuery *queryFollowerCount = [PFQuery queryWithClassName:@"Activity"];
    [queryFollowerCount whereKey:@"type" equalTo:@"follow"];
    [queryFollowerCount whereKey:@"toUser" equalTo:currentUser];
    [queryFollowerCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowerCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.subscribersCountLabel setText:[NSString stringWithFormat:@"%d", number]];
        }
    }];
    NSDictionary *followingDictionary = [[PFUser currentUser] objectForKey:@"following"];
    if (followingDictionary) {
        [self.subsCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[[followingDictionary allValues] count]]];
    }
    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:@"Activity"];
    [queryFollowingCount whereKey:@"type" equalTo:@"follow"];
    [queryFollowingCount whereKey:@"fromUser" equalTo:currentUser];
    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [self.subsCountLabel setText:[NSString stringWithFormat:@"%d", number]];
        }
    }];

    // Do any additional setup after loading the view.
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
