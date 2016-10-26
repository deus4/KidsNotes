//
//  KNNotesViewController.m
//  KiDSNotes
//
//  Created by deus4 on 25/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "KNNotesViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "YIInnerShadowView.h"
#import "KNNote.h"
#import "KNNoteTableViewCell.h"
#import "KNNoteDetailViewController.h"

@interface KNNotesViewController () <CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewTableViewHeader;
@property (strong, nonatomic) IBOutlet YIInnerShadowView *viewNewNote;
@property (nonatomic) NSMutableArray *eventsArray;
@property (nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITextField *noteTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) KNNote *noteToEdit;
@end

@implementation KNNotesViewController
{
    YIInnerShadowView* _innerShadowView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ЗАМЕТКИ";
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
    // Set self's events array to a mutable copy of the fetch results.
    [self setEventsArray:[fetchResults mutableCopy]];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSCurrentLocaleDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableView reloadData];
        
    }];
     */
   
    //_innerShadowView = (id)self.view.subviews[0];
    self.viewNewNote.shadowRadius = 4;
    self.viewNewNote.shadowMask = YIInnerShadowMaskBottom; 
    self.viewTableViewHeader.layer.borderWidth = 1;
    self.viewTableViewHeader.layer.borderColor = [UIColor blackColor].CGColor;
}
- (void)viewDidAppear:(BOOL)animated    {
    [super viewDidAppear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = app.managedObjectContext;
    // Start the location manager.
    [self.locationManager startUpdatingLocation];
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
    // Set self's events array to a mutable copy of the fetch results.
    [self setEventsArray:[fetchResults mutableCopy]];

    

    [self.tableView reloadData];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.locationManager = nil;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // There is only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // There are as many rows as there are obects in the events array.
    return [self.eventsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    KNNoteTableViewCell *cell = (KNNoteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    // Get the event corresponding to the current index path and configure the table view cell.
    KNNote *event = (KNNote *)self.eventsArray[indexPath.row];
    [cell configureWithNote:event];
    
    return cell;
}
#pragma mark - Editing

/*
 Handle deletion of an event.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Ensure that if the user is editing a name field then the change is committed before deleting a row -- this ensures that changes are made to the correct event object.
        [tableView endEditing:YES];
        
        // Delete the managed object at the given index path.
        NSManagedObject *eventToDelete = (self.eventsArray)[indexPath.row];
        [self.managedObjectContext deleteObject:eventToDelete];
        
        // Update the array and table view.
        [self.eventsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Commit the change.
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark - Table View Delegate
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить";
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath    {
    
    KNNote *note = (KNNote *)self.eventsArray[indexPath.row];
    self.noteToEdit = note;
    [self performSegueWithIdentifier:@"showNoteInMaster" sender:note];
    
}
#pragma mark - Editing text fields

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*
     Ensure that a text field for a row for a newly-inserted object is disabled when the user finishes editing.
     */
    textField.text = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        CLLocation *location = [self.locationManager location];
        if (!location) {
#ifdef DEBUG
            CLLocationDegrees latitude = random() * 720.0 / INT32_MAX  - 360.0;;
            CLLocationDegrees longitude = random() * 720.0 / INT32_MAX  - 360.0;;
            location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
#else
          //  return;
#endif
        }
        
        /*
         Create a new instance of the Event entity.
         */
        KNNote *eventObj = (KNNote *)[NSEntityDescription insertNewObjectForEntityForName:@"KNNote" inManagedObjectContext:self.managedObjectContext];
        
        // Configure the new event with information from the location.
        eventObj.creationDate = location.timestamp;
        
        
        /*
         Because this is a new event, and events are displayed with most recent events at the top of the list, add the new event to the beginning of the events array, then:
         * Add a new row to the table view
         * Scroll to make the row visible
         * Start editing the name field
         */
        [self.eventsArray insertObject:eventObj atIndex:0];
        
        CGPoint point = [textField center];
        point = [self.tableView convertPoint:point fromView:textField];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        KNNote *event = (self.eventsArray)[indexPath.row];
        event.name = self.noteTextField.text;
        
        // Commit the change.
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    [self.view endEditing:YES];
    textField.text = nil;
    
   
        
    [self.tableView reloadData];
    return YES;
}

#pragma mark - Location manager

/*
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager
{
    if (_locationManager != nil) {
        return _locationManager;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDelegate:self];
    
    return _locationManager;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"Location manager failed");
#else
    //self.addButton.enabled = NO;
#endif
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender  {
    if ([segue.identifier  isEqual:@"showNoteInMaster"]) {
        KNNoteDetailViewController *vc = [segue destinationViewController];
        vc.selectedNote = sender;
    }
}
@end
