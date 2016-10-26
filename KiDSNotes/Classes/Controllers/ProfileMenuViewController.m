//
//  ProfileMenuViewController.m
//  KiDSNotes
//
//  Created by deus4 on 27/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "ProfileMenuViewController.h"
#import "UIView+Fonts.h"
#import "ProfileMenuKidsCollectionViewCell.h"
#import "Children.h"
#import "DataManager.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ProfileMenuViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *profileLabels;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end

@implementation ProfileMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFonts];
   // PFUser *currentUser = [PFUser currentUser];
    //NSLog(currentUser.username);
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupFonts
{
    for (UILabel *profileLabel in self.profileLabels)
    {
        [profileLabel setKidsProGradeFiveFont];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdent = @"Cell";
    ProfileMenuKidsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdent forIndexPath:indexPath];
    Children *item = [[DATA childrenItems] objectAtIndex:indexPath.row];
    [cell.nameLabel setKidsProGradeFiveFont];
    [cell.ageLabel setKidsProGradeFiveFont];
    
    cell.nameLabel.text = item.name;
    cell.ageLabel.text = item.age;
    cell.pictureView.image = [UIImage imageNamed:item.picture];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[DATA childrenItems] count];
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
