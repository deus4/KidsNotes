//
//  IKFeedlineViewController.m
//  KiDSNotes
//
//  Created by deus4 on 29/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKFeedlineViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "ECSlidingSegue.h"
#import "IKKNCameraViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface IKFeedlineViewController ()
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (strong, nonatomic) IBOutlet UIButton *findFriendsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightMenuBarButton;


@end

@implementation IKFeedlineViewController
@synthesize firstLaunch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.findFriendsButton.layer.cornerRadius = 13.0f;
    NSDictionary *transitionData = self.transitions.all[3];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.slidingViewController.delegate = nil;
    } else {
        self.slidingViewController.delegate = transition;
    }
    
    NSString *transitionName = transitionData[@"name"];
    if ([transitionName isEqualToString:METransitionNameDynamic]) {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
       // self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    //    [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
     //   [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    }
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:UIColorFromRGB(0x009FE8),
       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:20]}];
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
    [self.rightMenuBarButton setImage:[[UIImage imageNamed:@"avatarPlaceholder"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    IKFeedlineTableViewController *feedLineTableViewController = self.childViewControllers.firstObject;
    [feedLineTableViewController loadObjects];
}
#pragma mark - PFQueryTableViewController
/*
 - (void)objectsDidLoad:(NSError *)error {
 [super objectsDidLoad:error];
 if (self.objects.count == 0 && ![[self queryForTable]hasCachedResult] & !self.firstLaunch) {
 self.tableView.scrollEnabled = NO;
 if (!self.blankTimelineView.superview) {
 self.blankTimelineView.alpha = 0.0f;
 self.tableView.tableHeaderView = self.blankTimelineView;
 [UIView animateWithDuration:0.200f animations:^{
 self.blankTimelineView.alpha = 1.0f;
 }];
 }
 }   else    {
 self.tableView.tableHeaderView = nil;
 self.tableView.scrollEnabled = YES;
 }
 }
 */
#pragma mark - Properties
- (IBAction)menuButtonAction:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
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
- (IBAction)openCamera:(id)sender {
    
    
    [self.navigationController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"openCamera"] animated:YES completion:nil];
    
}

- (IBAction)rightMenuAction:(id)sender {
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
}


@end
