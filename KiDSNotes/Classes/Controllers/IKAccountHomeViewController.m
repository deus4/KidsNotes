//
//  IKAccountHomeViewController.m
//  KiDSNotes
//
//  Created by deus4 on 28/04/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKAccountHomeViewController.h"
#import "KNIKAccountViewController.h"
@interface IKAccountHomeViewController ()

@end

@implementation IKAccountHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    KNIKAccountViewController *myController = [self.childViewControllers firstObject];
    [myController loadObjects];
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
