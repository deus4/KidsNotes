//
//  MenuViewController.m
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "DataManager.h"
#import "Menu.h"
#import "UIView+Fonts.h"
#import "UIViewController+ECSlidingViewController.h"
#import <Parse/Parse.h>
#import "PFImageView.h"

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundPicture;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.profileNameLabel setKidsProGradeFiveFont];
        [self getCurrentUserData];
    self.tableView.scrollEnabled = NO;
    

   
   // [self.slidingViewController resetTopViewAnimated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    [self.transitionsNavigationController.view layoutIfNeeded];

}
-(void)viewWillLayoutSubviews
{
        [self.backgroundPicture invalidateIntrinsicContentSize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getCurrentUserData {
    
    NSString *userID = [[PFUser currentUser]valueForKey:@"objectId"];

    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:userID block:^(PFObject *gameScore, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSString *firstName = gameScore[@"firstName"];
        NSString *lastName = gameScore[@"lastName"];
        NSString *qandaString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];

        self.profileNameLabel.text = qandaString;
        
        PFFile *imageFile = gameScore[@"profilePicture"];
        
        [self.profilePicture setFile:imageFile];
        
        self.profilePicture.clipsToBounds = YES;
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
        [self.profilePicture loadInBackground:^(UIImage *image, NSError *error) {
        }];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Menu *item = [[DATA menuItems] objectAtIndex:indexPath.row];
    [cell.titleLabel setKidsProGradeFiveFont];
    cell.titleLabel.text = [item.title uppercaseString];
    cell.imageView.image = [UIImage imageNamed:item.icon];
    cell.imageView.clipsToBounds = YES;

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DATA menuItems] count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Menu *item = [[DATA menuItems] objectAtIndex:indexPath.row];
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    if (item.menuId == nil) {

    }
    if (item.menuId!=nil) {
        
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:item.menuId];
    }
    
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)feedLineButtonTouchUpInside:(id)sender {
    self.slidingViewController.topViewController = self.transitionsNavigationController;
    [self.slidingViewController resetTopViewAnimated:YES];

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
