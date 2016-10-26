//
//  IKSlidingViewController.m
//  KiDSNotes
//
//  Created by deus4 on 01/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKSlidingViewController.h"
#import "IKFeedlineViewController.h"
#import "IKMenuViewController.h"
#import "RightMenuViewController.h"

@interface IKSlidingViewController ()

@end

@implementation IKSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *topStoryboard = [UIStoryboard storyboardWithName:@"Feedline" bundle: nil];
    UIStoryboard *menuStoryboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    IKFeedlineViewController *topViewController = [topStoryboard instantiateViewControllerWithIdentifier:@"feedLine"];
    IKMenuViewController *underLeftViewController = [menuStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    RightMenuViewController *underRightViewController = [menuStoryboard instantiateViewControllerWithIdentifier:@"RightMenuController"];
    UINavigationController *navigationController = (UINavigationController *)[menuStoryboard instantiateViewControllerWithIdentifier:@"FeedlineNavigation"];
    underLeftViewController.edgesForExtendedLayout = UIRectEdgeTop;
    
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
