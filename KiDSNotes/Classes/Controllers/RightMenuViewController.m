//
//  RightMenuViewController.m
//  KiDSNotes
//
//  Created by deus4 on 27/06/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "RightMenuViewController.h"
#import "ECSlidingViewController.h"
#import "METransitions.h"
#import "UIViewController+ECSlidingViewController.h"
#import "RightMenuChildrenTableViewCell.h"
#import "IKChlidrenInfo.h"
#import "ECSlidingSegue.h"
#import "IKKNNotesViewController.h"
#import "ProgressHUD.h"

static NSString *SectionHeaderViewIdentifier = @"IKRightSectionHeaderView";
static NSString *SectionFooterViewIdentifier = @"IKRightMenuFooterView";

@interface RightMenuViewController ()
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) NSMutableArray *childrenList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) NSMutableArray *sectionInfoArray;
@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 40
#define HEADER_HEIGHT 50

@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.childrenList = [NSMutableArray array];
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    self.openSectionIndex = NSNotFound;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"IKRightSectionHeaderView" bundle:nil];
    UINib *sectionFooterNib = [UINib nibWithNibName:@"IKRightMenuFooterView" bundle:nil];
    [self.tableView registerNib:sectionFooterNib forHeaderFooterViewReuseIdentifier:SectionFooterViewIdentifier];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    [self loadChildrenList];
    // Do any additional setup after loading the view.

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadChildrenList];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.sectionInfoArray = nil;
    
    IKRightSectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
   // sectionHeaderView.disclosureButton.selected = false;
    if (self.openSectionIndex >= 0 && self.openSectionIndex <= 3) {
        [self sectionHeaderView:sectionHeaderView sectionClosed:self.openSectionIndex];
      //  [sectionHeaderView toggleOpenWithUserAction:true];
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)loadChildrenList {
    [ProgressHUD show:@"Обновляем" Interaction:NO];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Children"];
    [query whereKey:@"Parent" equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            [self.childrenList removeAllObjects];
            [self.childrenList addObjectsFromArray:objects];
            if ((self.sectionInfoArray == nil) ||
                ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
                
                // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
                NSMutableArray *infoArray = [[NSMutableArray alloc] init];
                
                for (PFObject *children in self.childrenList) {
                    
                    IKChlidrenInfo *sectionInfo = [[IKChlidrenInfo alloc] init];
                    sectionInfo.children = children;
                    sectionInfo.open = NO;
                    
                    NSNumber *defaultRowHeight = @(DEFAULT_ROW_HEIGHT);
                    NSInteger countOfQuotations = 2;
                    for (NSInteger i = 0; i < countOfQuotations; i++) {
                        [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                    }
                    
                    [infoArray addObject:sectionInfo];
                }
                
                self.sectionInfoArray = infoArray;
                [self.tableView reloadData];

            }
            [ProgressHUD dismiss];


        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}
- (IBAction)menuButtonAction:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.childrenList count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    IKChlidrenInfo *sectionInfo = (self.sectionInfoArray)[section];
    NSInteger numStoriesInSection = 2;
    
    return sectionInfo.open ? numStoriesInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RightMenuChildrenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.rightContentButton.tag = indexPath.section;
    if (indexPath.row == 0) {
        [cell.rightContentButton setTitle:@"Календарь" forState:UIControlStateNormal];
        [cell.rightContentButton setImage:[UIImage imageNamed:@"calendarButtonPDF"] forState:UIControlStateNormal];
        [cell.rightContentButton addTarget:self action:@selector(OpenCalendarTapped:)  forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.row == 1) {
        [cell.rightContentButton setTitle:@"Заметки" forState:UIControlStateNormal];
        [cell.rightContentButton setImage:[UIImage imageNamed:@"notesButtonPDF"] forState:UIControlStateNormal];
        [cell.rightContentButton addTarget:self action:@selector(OpenNotesTapped:)  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
- (void)OpenCalendarTapped:(UIButton *)button {
    PFObject *object = [self.childrenList objectAtIndex:button.tag];
    [self performSegueWithIdentifier:@"showCalendar" sender:object];

}
- (void)OpenNotesTapped:(UIButton *)button {
    PFObject *object = [self.childrenList objectAtIndex:button.tag];
    [self.slidingViewController.underRightViewController performSegueWithIdentifier:@"childrenNotes" sender:object];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    IKRightSectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    IKChlidrenInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;
    PFFile *imageFile = [sectionInfo.children objectForKey:@"photo"];
    NSString *childrenName = [sectionInfo.children valueForKey:@"name"];
    sectionHeaderView.disclosureButton.selected = false;
    sectionHeaderView.childrenNameLabel.text = childrenName.uppercaseString;
    [sectionHeaderView.childrenImageView setFile:imageFile];
    [sectionHeaderView.childrenImageView loadInBackground];
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IKChlidrenInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *sectionFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionFooterViewIdentifier];
    return sectionFooter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 22.0f;
}
#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(IKRightSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    IKChlidrenInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
    
    sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = 2;
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
        IKChlidrenInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = 2;
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(IKRightSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    IKChlidrenInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier  isEqual: @"childrenNotes"]) {
        ECSlidingSegue *slidingSegue = (ECSlidingSegue *)segue;
        slidingSegue.skipSettingTopViewController = YES;
        PFObject *userObject = sender;
        IKKNNotesViewController *vc = [slidingSegue destinationViewController];
        vc.children = userObject;
        self.slidingViewController.topViewController = vc;
        [self.slidingViewController resetTopViewAnimated:YES];

     //   [self.slidingViewController resetTopViewAnimated:YES];
    }
    if ([segue.identifier isEqualToString:@"showCalendar"]) {
        
    }
    
}

- (IBAction)goSettings:(id)sender {
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Profile children settings"];
    [self.slidingViewController resetTopViewAnimated:YES];

}

@end
