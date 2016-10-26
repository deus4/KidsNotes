//
//  RightMenuViewController.h
//  KiDSNotes
//
//  Created by deus4 on 27/06/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "IKRightSectionHeaderView.h"

@interface RightMenuViewController : UIViewController <ECSlidingViewControllerDelegate, UITableViewDelegate,UITableViewDataSource,SectionHeaderViewDelegate>

@end
