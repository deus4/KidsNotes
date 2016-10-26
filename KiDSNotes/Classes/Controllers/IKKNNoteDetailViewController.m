//
//  IKKNNoteDetailViewController.m
//  KiDSNotes
//
//  Created by deus4 on 24/03/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNNoteDetailViewController.h"

@interface IKKNNoteDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;

@end

@implementation IKKNNoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM yyyy HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:[self.noteObject createdAt]];
    self.dateLabel.text = dateString;
    self.noteTextView.text = [self.noteObject valueForKey:@"text"];
    // Do any additional setup after loading the view.
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
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
- (IBAction)goBack:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self.noteObject setValue:self.noteTextView.text forKey:@"text"];
    [self.noteObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];

}
- (IBAction)deleteNote:(id)sender {
    [self.noteObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
