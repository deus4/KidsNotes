//
//  ViewController.m
//  KiDSNotes
//
//  Created by deus4 on 27/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "ViewController.h"

#import "MEZoomAnimationController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface ViewController ()
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    // enable swiping on the top view
    
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
      //  self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
     //   [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
    //    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    }

    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:UIColorFromRGB(0x009FE8),
       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:18]}];
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
    
    
    
}
- (void)viewWillAppear:(BOOL)animated    {
    
    [super viewWillAppear:animated];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)menuButtonAction:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Properties

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
- (IBAction)openCameraAccount:(UIButton *)sender {
        [self.navigationController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"openCamera"] animated:YES completion:nil];
}


@end
