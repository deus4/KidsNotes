//
//  SetUpViewController.m
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "SetUpViewController.h"

@interface SetUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *allowLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *allowNotificationButton;
@property (weak, nonatomic) IBOutlet UIButton *getmeinButton;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allowLocationButton.hidden = YES;
    self.allowNotificationButton.hidden = YES;
    self.doneButton.hidden = YES;
    self.dataLabel.hidden = YES;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
- (IBAction)getMeInButtonTouch:(id)sender {
    self.allowLocationButton.hidden = NO;
    self.allowNotificationButton.hidden = NO;
    self.dataLabel.hidden = NO;
    self.getmeinButton.hidden = YES;
}
- (IBAction)allowLocationTouch:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self checkIfSelected];
}
- (IBAction)allowNotificationTouch:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self checkIfSelected];
}

-(void)checkIfSelected
{
    
    if (self.allowLocationButton.selected && self.allowNotificationButton.selected) {
        self.doneButton.hidden = NO;
    }   else {
        self.doneButton.hidden = YES;
    }
}
- (IBAction)allowNotificationsTouchUp:(id)sender {
    // Register for Push Notitications

}

@end
