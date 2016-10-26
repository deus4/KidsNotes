//
//  FLCommentsViewController.m
//  KiDSNotes
//
//  Created by deus4 on 05/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "FLCommentsViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "FLComments.h"
#import "UIView+Fonts.h"
#import "KNPhotoDetailsViewController.h"

static NSString * const CellIdentifier = @"Cell";

@interface FLCommentsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIView *showTableView;

@end

@implementation FLCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"КОМЕНТАРИИ";
    [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
    [self loadFonts];
  //  KNPhotoDetailsViewController *photoDetailsComments = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoDetail"];
    //[self.showTableView addSubview:photoDetailsComments.view];
   // [self addChildViewController:photoDetailsComments];
    
    // Do any additional setup after loading the view.
}

- (void)loadFonts
{
    [self.sendButton setKidsProGradeFiveFont];
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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}
- (IBAction)swipeBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)barButtonTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}





@end
