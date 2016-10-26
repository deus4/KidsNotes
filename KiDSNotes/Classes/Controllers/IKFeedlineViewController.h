//
//  IKFeedlineViewController.h
//  KiDSNotes
//
//  Created by deus4 on 29/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "IKFeedlineTableViewController.h"

@interface IKFeedlineViewController : UIViewController <ECSlidingViewControllerDelegate>

@property (nonatomic, assign, getter = isFirstLaunch) BOOL firstLaunch;
@property (strong, nonatomic) IBOutlet UIView *blankTimelineView;

@end
