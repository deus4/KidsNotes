//
//  KNNoteDetailViewController.m
//  KiDSNotes
//
//  Created by deus4 on 26/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "KNNoteDetailViewController.h"
#import "KNNote.h"
#import "AppDelegate.h"
@interface KNNoteDetailViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *noteTextView;


@end

@implementation KNNoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.managedObjectContext = self.selectedNote.managedObjectContext;
    self.noteTextView.text = self.selectedNote.name;
}
- (IBAction)deleteNoteAction:(id)sender {
    // Delete the managed object at the given index path.
    NSManagedObject *eventToDelete = self.selectedNote;
    [self.managedObjectContext deleteObject:eventToDelete];
    
    
    // Commit the change.
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    KNNote *note = self.selectedNote;
    note.name = textView.text;
    
    // Commit the change.
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return YES;
}
@end
