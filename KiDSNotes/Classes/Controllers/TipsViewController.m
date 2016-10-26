//
//  TipsViewController.m
//  KiDSNotes
//
//  Created by deus4 on 17/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "TipsViewController.h"
#import "UIView+Fonts.h"
@interface TipsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation TipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFonts];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadFonts {
    [self.tipLabel setKidsProGradeFiveFont];
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
