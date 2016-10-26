//
//  ForumViewController.m
//  KiDSNotes
//
//  Created by deus4 on 23/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "ForumViewController.h"
#import "FriendsForumViewController.h"
#import "FirstDaysViewController.h"
#import "TTUIScrollViewSlidingPages.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ForumViewController () <TTSlidingPagesDataSource, TTSliddingPageDelegate>
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) TTScrollSlidingPagesController *slider;
@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KIDSNOTES";
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    //propertys
    self.slider.disableUIPageControl = YES;
    self.slider.titleScrollerTextDropShadowColour = [UIColor clearColor];
    self.slider.disableTitleShadow = YES;
    self.slider.titleScrollerInActiveTextColour = [UIColor grayColor];
    self.slider.titleScrollerTextFont = [UIFont fontWithName:@"PFKidsPro-GradeFive" size:20];
    self.slider.titleScrollerTextColour = [UIColor blackColor];
    self.slider.titleScrollerBackgroundColour = [UIColor clearColor];
    self.slider.disableTitleScrollerShadow = YES;
    self.slider.triangleBackgroundColour = [UIColor clearColor];
    //end
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.view layoutSubviews];
    NSLog(@"it should happenWill...");
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.slider.dataSource = self; /*the current view controller (self) conforms to the TTSlidingPagesDataSource protocol)*/
    self.slider.view.frame = self.sliderView.frame; //I'm setting up the view to be fullscreen in the current view
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
    [self.view layoutSubviews];
    NSLog(@"it should happenDid...");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TTSlidingPagesDataSource methods
-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return 2;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    UIViewController *viewController;
    // myView.frame = self.sliderView.frame;
    if (index == 0){ //just an example, alternating views between one
        //        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tips"];
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsForum"];
    }
    if (index == 1)
    {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstDays"];
        
    }
    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
}
-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
    if (index == 0){
        //use a image as the header for the first page
        title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"ДРУЖИЛКА"];
    }
    else {
        switch (index) {
            case 1:
                title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"ПЕРВЫЕ ДНИ С МАЛЫШОМ"];
                break;
        }
    }
    //all other pages just use a simple text header
    
    
    return title;
}
-(void)didScrollToViewAtIndex:(NSUInteger)index
{
    
    NSLog(@"scrolled to view");
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
