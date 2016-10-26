//
//  FeedViewController.m
//  KiDSNotes
//
//  Created by deus4 on 02/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "FeedViewController.h"
#import "DataManager.h"
#import "FLTableViewCell.h"
#import "FeedLine.h"
#import "UIView+Fonts.h"

#import "Parse.h"
#import "PAPConstants.h"
#import "KNFeedLineViewController.h"

@interface FeedViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewToDisplay;
@property (strong ,nonatomic) KNFeedLineViewController *feedLineVC;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ЛЕНТА";

    self.feedLineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedLineView"];
    self.feedLineVC.view.frame = self.viewToDisplay.bounds;
    [self.viewToDisplay addSubview:self.feedLineVC.view];
    [self addChildViewController:self.feedLineVC];
    //[myView didMoveToParentViewController:self];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.feedLineVC loadObjects];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}

- (IBAction)openCamera:(id)sender {
    [self.navigationController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"cameraSlidingScene"] animated:YES completion:nil];
}

@end
