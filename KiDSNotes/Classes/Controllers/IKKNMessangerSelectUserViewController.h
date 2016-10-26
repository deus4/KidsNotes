//
//  IKKNMessangerSelectUserViewController.h
//  KiDSNotes
//
//  Created by deus4 on 30/06/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "ViewController.h"
@protocol SelectSingleDelegate
- (void)didSelectSingleUser:(PFUser *)user;
@end

@interface IKKNMessangerSelectUserViewController : UIViewController
@property (nonatomic, assign) id<SelectSingleDelegate>delegate;
@end
