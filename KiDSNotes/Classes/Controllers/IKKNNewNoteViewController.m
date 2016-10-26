//
//  IKKNNewNoteViewController.m
//  KiDSNotes
//
//  Created by deus4 on 24/03/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNNewNoteViewController.h"
#import "KNNote.h"
#import "AppDelegate.h"
@interface IKKNNewNoteViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation IKKNNewNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM yyyy h:mm"];
    NSString *dateString = [dateFormat stringFromDate:today];
    [self.doneButton setTitleTextAttributes:@{NSFontAttributeName :[UIFont fontWithName:@"Roboto-Light" size:18.0]} forState:UIControlStateNormal];
    self.dateLabel.text = dateString;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",[self.children valueForKey:@"name"]);
    /*    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = app.managedObjectContext;
     */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)returnBack:(id)sender {
    /*
    NSDate *today = [NSDate date];
    KNNote *eventObj = (KNNote *)[NSEntityDescription insertNewObjectForEntityForName:@"KNNote" inManagedObjectContext:self.managedObjectContext];
    eventObj.creationDate = today;
    // Commit the change.
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    eventObj.name = self.noteTextView.text;
   // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveNote:(id)sender {
    NSDate *today = [NSDate date];
    KNNote *eventObj = (KNNote *)[NSEntityDescription insertNewObjectForEntityForName:@"KNNote" inManagedObjectContext:self.managedObjectContext];
    eventObj.creationDate = today;
    // Commit the change.
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    eventObj.name = self.noteTextView.text;

     */
    if (self.noteTextView.text.length == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    } else {
        PFObject *note = [PFObject objectWithClassName:@"Note"];
        [note setObject:self.children forKey:@"createdBy"];
        [note setValue:self.noteTextView.text forKey:@"text"];
        [note saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }


    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.noteTextView.text.length == 0) {
        return;
    } else {
        PFObject *note = [PFObject objectWithClassName:@"Note"];
        [note setObject:self.children forKey:@"createdBy"];
        [note setValue:self.noteTextView.text forKey:@"text"];
        [note saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    /*
    NSDate *today = [NSDate date];
    KNNote *eventObj = (KNNote *)[NSEntityDescription insertNewObjectForEntityForName:@"KNNote" inManagedObjectContext:self.managedObjectContext];
    eventObj.creationDate = today;
    // Commit the change.
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    eventObj.name = self.noteTextView.text;
     */

  //  [self.navigationController popViewControllerAnimated:YES];

}
@end
