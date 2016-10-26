//
//  KNAccountViewController.m
//  KiDSNotes
//
//  Created by deus4 on 24/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNAccountViewController.h"

@interface KNAccountViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@end

@implementation KNAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePictureImageView.layer.cornerRadius = 30.0f;
    self.profilePictureImageView.layer.masksToBounds = YES;
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

@end
