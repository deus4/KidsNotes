//
//  IKKNNotesViewController.m
//  KiDSNotes
//
//  Created by deus4 on 24/03/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNNotesViewController.h"
#import "KNNote.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "IKKNNoteDetailViewController.h"
#import "IKKNNotesCell.h"
#import "TTTTimeintervalFormatter.h"
#import "UIViewController+ECSlidingViewController.h"
#import "IKKNNewNoteViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface IKKNNotesViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) KNNote *noteToEdit;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormat;
@property (strong, nonatomic) IBOutlet UIButton *createNoteButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteAllNotesButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteSingleNoteButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *notesBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightMenuBarButton;
@property (strong, nonatomic) NSArray *notesArray;

@end

@implementation IKKNNotesViewController
@synthesize timeIntervalFormatter;
@synthesize children;
@synthesize notesArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.editButton setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x595968),
                                              NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:18]} forState:UIControlStateNormal];
    self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc]init];
    
    self.dateFormat = [[NSDateFormatter alloc]init];
    [self.dateFormat setDateFormat:@"dd/MM/yy"];
    self.tableView.allowsMultipleSelectionDuringEditing = true;
    self.deleteAllNotesButton.hidden = true;
    self.deleteSingleNoteButton.hidden = true;
    /*
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = app.managedObjectContext;
     */
    NSString *childrenName = [self.children valueForKey:@"name"];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               UIColorFromRGB(0x009FE8),
                                               NSForegroundColorAttributeName,
                                               [UIFont fontWithName:@"Roboto-Medium" size:20.0],
                                               NSFontAttributeName,
                                               nil];
    [self.notesBar setTitleTextAttributes:navbarTitleTextAttributes];

    self.notesBar.topItem.title = childrenName;
    [self.rightMenuBarButton setImage:[[UIImage imageNamed:@"avatarPlaceholder"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PFQuery *notesQuery = [PFQuery queryWithClassName:@"Note"];
    [notesQuery whereKey:@"createdBy" equalTo:self.children];
    [notesQuery orderByDescending:@"createdAt"];
    [notesQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.notesArray = [[NSArray alloc]initWithArray:objects];
            [self.tableView reloadData];
        }
    }];
    /*
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"KNNote"];
    [request setFetchBatchSize:20];
    
    // Order the events by creation date, most recent first.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    // Execute the fetch.
    NSError *error;
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    // Set self's events array to a mumenuBtable copy of the fetch results.
    [self setEventsArray:[fetchResults mutableCopy]];
    
    */
    
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // There are as many rows as there are obects in the events array.
    //return [self.eventsArray count];
    return [self.notesArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    IKKNNotesCell *cell = (IKKNNotesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    PFObject *note = [self.notesArray objectAtIndex:indexPath.row];
    cell.noteTitle.text = [note valueForKey:@"text"];
    NSTimeInterval timeInterval = [[note createdAt] timeIntervalSinceNow];
    NSString *timeStamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
    cell.timeStampLabel.text = timeStamp;
    // Get the event corresponding to the current index path and configure the table view cell.
    /*
    KNNote *event = (KNNote *)self.eventsArray[indexPath.row];
    cell.noteTitle.text = event.name;
    NSTimeInterval timeInterval = [[event creationDate] timeIntervalSinceNow];
    
    */
    return cell;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath    {
    KNNote *note = (KNNote *)self.eventsArray[indexPath.row];
    PFObject *noteObject = self.notesArray[indexPath.row];
    if (self.tableView.isEditing) {
        self.deleteAllNotesButton.hidden = true;
        self.deleteSingleNoteButton.hidden = false;
        return;
    } else {
        
        [self performSegueWithIdentifier:@"noteDetail" sender:noteObject];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *selectedIndexPath = [tableView indexPathsForSelectedRows];
    
    if (!selectedIndexPath || !selectedIndexPath.count){
        self.deleteAllNotesButton.hidden = false;
        self.deleteSingleNoteButton.hidden = true;
    }
}
- (IBAction)deleteSelected:(UIButton *)sender {
    NSArray *selectedIndexPath = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *object in selectedIndexPath) {
        NSLog(@"%i",object.row);
        KNNote *noteObject = (KNNote *)self.eventsArray[object.row];
        [self.eventsArray removeObjectAtIndex:object.row];
        NSManagedObjectContext *context = [noteObject managedObjectContext];
        [context deleteObject:noteObject];
        NSError *error;
        if (![context save:&error]) {
            // Handle the error.
        }
    }
    [self.tableView reloadData];
    
    
    
}
- (IBAction)showRightMenu:(id)sender {
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
}
- (IBAction)deleteAllNotes:(UIButton *)sender {
    for (KNNote * note in self.eventsArray) {
        [self.managedObjectContext deleteObject:note];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
    [self.eventsArray removeAllObjects];
    [self.tableView reloadData];
    
}
- (IBAction)editMode:(id)sender {
    
}
- (IBAction)editModeButton:(UIBarButtonItem *)sender {
    
    if ([sender.title  isEqual: @"Edit"])    {
        sender.title = @"Cancel";
        [self.tableView setEditing:YES animated:YES];
        self.createNoteButton.hidden = true;
        self.deleteAllNotesButton.hidden = false;
        return;
    }
    if ([sender.title isEqualToString:@"Cancel"]) {
        sender.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
        self.createNoteButton.hidden = false;
        self.deleteAllNotesButton.hidden = true;
        self.deleteSingleNoteButton.hidden = true;
        
        return;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"noteDetail"]) {
        IKKNNoteDetailViewController *vc = [segue destinationViewController];
        vc.noteObject = sender;
    }
    if ([segue.identifier isEqualToString:@"newNoteSegue"]) {
        IKKNNewNoteViewController *viewController = [segue destinationViewController];
        viewController.children = self.children;
    }
}


@end
