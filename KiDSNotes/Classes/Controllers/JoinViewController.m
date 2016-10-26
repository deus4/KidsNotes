//
//  JoinViewController.m
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "JoinViewController.h"
#import <Parse/Parse.h>

@interface JoinViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *loader;

@end

@implementation JoinViewController

- (UIActivityIndicatorView *)loader
{
    if (nil == _loader) {
        _loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loader.hidesWhenStopped = YES;
        _loader.center = self.view.center;
        [self.view addSubview:_loader];
    }
    return _loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([PFUser currentUser]) {
        [self.loader startAnimating];
        return;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser]) {
        [self.navigationController performSegueWithIdentifier:@"mainSceneSegue" sender:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.loader stopAnimating];
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
