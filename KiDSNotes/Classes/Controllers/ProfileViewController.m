//
//  ProfileViewController.m
//  KiDSNotes
//
//  Created by deus4 on 16/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIView+Fonts.h"
#import "Children.h"
#import "DataManager.h"
#import "ProfileMenuKidsCollectionViewCell.h"
#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "TipsViewController.h"
#import "CalendarViewController.h"
#import "Parse.h"
#import "PFImageView.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate,TTSlidingPagesDataSource, TTSliddingPageDelegate>
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicationsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribersNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribersLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addButtonLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *kidsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) TTScrollSlidingPagesController *scrollSlider;
@property (weak, nonatomic) UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    
    self.title = @"KIDSNOTES";
    [super viewDidLoad];
    [self.kidsCollectionView setTransform:CGAffineTransformMakeScale(-1, 1)];
    [self loadCustomFonts];
    self.scrollSlider = [[TTScrollSlidingPagesController alloc] init];
    //properties before
    self.scrollSlider.disableUIPageControl = YES;
    self.scrollSlider.titleScrollerTextDropShadowColour = [UIColor clearColor];
    self.scrollSlider.disableTitleShadow = YES;
    self.scrollSlider.titleScrollerInActiveTextColour = [UIColor grayColor];
    self.scrollSlider.titleScrollerTextFont = [UIFont fontWithName:@"PFKidsPro-GradeFive" size:20];
    self.scrollSlider.titleScrollerTextColour = [UIColor blackColor];
    self.scrollSlider.titleScrollerBackgroundColour = [UIColor clearColor];
    self.scrollSlider.disableTitleScrollerShadow = YES;
    /*the current view controller (self) conforms to the TTSlidingPagesDataSource protocol)*/
    self.scrollSlider.triangleBackgroundColour = [UIColor clearColor];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollSlider.dataSource = self;
    
    self.scrollSlider.view.frame = self.sliderView.frame;
    
    [self.view addSubview: self.scrollSlider.view];
    // Do any additional setup after loading the view.
    [self addChildViewController: self.scrollSlider];
    [self.view layoutSubviews];
     [self getCurrentUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCurrentUserData {
    NSString *userID = [[PFUser currentUser]valueForKey:@"objectId"];
    NSLog(@"user ID = %@", userID);
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:userID block:^(PFObject *gameScore, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSString *firstName = gameScore[@"firstName"];
        NSString *lastName = gameScore[@"lastName"];
        NSString *qandaString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
    //    PFFile *profilePicutre = gameScore[@"profilePicture"];
      //  self.profilePicture.image = profilePicutre;
        self.profileNameLabel.text = qandaString;
        NSLog(@"%@", gameScore);
        
        PFFile *imageFile = gameScore[@"profilePicture"];
        [self.profilePicture setFile:imageFile];
        self.profilePicture.clipsToBounds = YES;
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
        [self.profilePicture loadInBackground:^(UIImage *image, NSError *error) {


        
        
        
    }];
         }];
    // The InBackground methods are asynchronous, so any code after this will run
    // immediately.  Any code that depends on the query result should be moved
    // inside the completion block above.

    // The InBackground methods are asynchronous, so any code after this will run
    // immediately.  Any code that depends on the query result should be moved
    // inside the completion block above.
}

#pragma mark - Custom fonts
- (void)loadCustomFonts
{
    [self.profileNameLabel setKidsProGradeFiveFont];
    [self.publicationsNumberLabel setKidsProGradeFiveFont];
    [self.subscribersNumberLabel setKidsProGradeFiveFont];
    [self.subscriptionsNumberLabel setKidsProGradeFiveFont];
    [self.addButtonLabel setKidsProGradeFiveFont];
    [self.publicationsLabel setKidsProGradeOneFont];
    [self.subscribersLabel setKidsProGradeOneFont];
    [self.subscriptionsLabel setKidsProGradeOneFont];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Collection View
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
    [cell.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[DATA childrenItems] count];
}

#pragma mark TTSlidingPagesDataSource methods
-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return 1; //just return 3 pages
}
-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    UIViewController *viewController;
    
    // myView.frame = self.sliderView.frame;
    if (index == 0){ //just an example, alternating views between one
//        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tips"];
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"photos"];
    }
//    if (index == 1)
//    {
//          viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"calendar"];
//      
//    }
//    if (index == 2) {
//        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tips"];
//       
//    }
    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
}
-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
    if (index == 0){
        //use a image as the header for the first page
     title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Фотографии"];
    }
//    else {
//        switch (index) {
//            case 1:
//                title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Календарь"];
//                break;
//            case 2:
//                title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Полезные советы"];
//                break;
//        }
//    }
    //all other pages just use a simple text header
  

    return title;
}

-(void)didScrollToViewAtIndex:(NSUInteger)index
{
    
    NSLog(@"scrolled to view");
}
- (IBAction)openCamera:(id)sender {
    [self.navigationController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"cameraSlidingScene"] animated:YES completion:nil];
}

@end
