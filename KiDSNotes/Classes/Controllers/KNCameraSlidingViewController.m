//
//  KNCameraSlidingViewController.m
//  KiDSNotes
//
//  Created by deus4 on 18/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNCameraSlidingViewController.h"
#import "TTScrollSlidingPagesController.h"
#import "TTUIScrollViewSlidingPages.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface KNCameraSlidingViewController ()<TTSlidingPagesDataSource>
@property (strong, nonatomic) TTScrollSlidingPagesController *slider;
@end

@implementation KNCameraSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    //propertys
    self.slider.disableUIPageControl = YES;
    self.slider.titleScrollerTextDropShadowColour = [UIColor clearColor];
    self.slider.disableTitleShadow = YES;
    self.slider.titleScrollerInActiveTextColour = [UIColor grayColor];
    self.slider.titleScrollerTextFont = [UIFont fontWithName:@"PFKidsPro-GradeFive" size:20];
    self.slider.titleScrollerTextColour = UIColorFromRGB(0xF8F6F7);
    self.slider.titleScrollerBackgroundColour = UIColorFromRGB(0x202125);

    self.slider.disableTitleScrollerShadow = YES;
    self.slider.triangleBackgroundColour = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.slider.dataSource = self; /*the current view controller (self) conforms to the TTSlidingPagesDataSource protocol)*/
    self.slider.view.frame = self.view.frame; //I'm setting up the view to be fullscreen in the current view
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
    [self.view layoutSubviews];
    
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
#pragma mark - TTScrollSlidingPagesController
-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return 2;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    UIViewController *viewController;
    // myView.frame = self.sliderView.frame;
    if (index == 0){ //just an example, alternating views between one
        //        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tips"];
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewScene"];
    }
    if (index == 1)
    {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewScene"];
        
    }
    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
}
-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
    if (index == 0){
        //use a image as the header for the first page
        title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"КАМЕРА"];
    }
    else {
        switch (index) {
            case 1:
                title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"ФОТОАЛЬБОМ"];
                break;
        }
    }
    //all other pages just use a simple text header
    
    
    return title;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
