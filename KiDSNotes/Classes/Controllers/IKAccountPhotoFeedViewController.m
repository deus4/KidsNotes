//
//  IKAccountPhotoFeedViewController.m
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKAccountPhotoFeedViewController.h"
#import "IKAccountPhotoFeedCollectionViewCell.h"
@interface IKAccountPhotoFeedViewController ()

@end

@implementation IKAccountPhotoFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (PFQuery *)queryForTable  {
    PFUser *user = [PFUser currentUser];
    [[PFUser currentUser]fetchIfNeeded];
    
    
    
    if (!user) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"user" equalTo:user];
    [query includeKey:@"user"];
    
    return query;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(nullable PFObject *)object;    {
    static NSString *identfiier = @"Cell";
    
    IKAccountPhotoFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identfiier forIndexPath:indexPath];
    
    
    
    
    // IKChildrenAccountCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath object:object];
    
    NSLog(@"%@",object);
    // cell.textLabel.text = [object objectForKey:@"name"];
    cell.feedImage.file = [object objectForKey:@"image"];
    [cell.feedImage loadInBackground];
    return cell;
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
