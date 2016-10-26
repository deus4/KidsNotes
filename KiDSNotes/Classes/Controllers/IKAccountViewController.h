//
//  IKAccountViewController.h
//  KiDSNotes
//
//  Created by deus4 on 09/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKFeedlineTableViewController.h"

@interface IKAccountViewController : IKFeedlineTableViewController

@property (nonatomic, strong) PFUser *user;

- (id)initWithUser:(PFUser *)aUser;

@end
