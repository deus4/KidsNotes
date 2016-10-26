//
//  SettingsViewController.m
//  KiDSNotes
//
//  Created by deus4 on 03/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIView+Fonts.h"
#import "UIViewController+ECSlidingViewController.h"
#import <Parse/Parse.h>
#import "JoinViewController.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollectionKidsPro;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollectionKidsPro;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KIDSNOTES";
    [self setupFonts];
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
- (void)setupFonts
{
    for (UILabel *label in self.labelCollectionKidsPro)
    {
        [label setKidsProGradeFiveFont];
    }
    for (UIButton *button in self.buttonCollectionKidsPro)
    {
        [button setKidsProGradeFiveFont];
    }
}
- (IBAction)exitButtonTouch:(id)sender {
    [PFUser logOut];
    [self showLogInPage];
}

- (void)showLogInPage
{
    JoinViewController *logInController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
    [self presentViewController:logInController animated:YES completion:nil];
}

@end
