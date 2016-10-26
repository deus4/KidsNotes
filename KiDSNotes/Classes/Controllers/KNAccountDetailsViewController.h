  //
//  KNAccountDetailsViewController.h
//  KiDSNotes
//
//  Created by deus4 on 25/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "KNFeedLineViewController.h"

@interface KNAccountDetailsViewController : KNFeedLineViewController

@property (nonatomic, strong) PFUser *user;
- (id)initWithUser:(PFUser *)aUser;

@end
