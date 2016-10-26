//
//  SelectSingleView.h
//  KiDSNotes
//
//  Created by deus4 on 20/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@protocol KNSelectSingleDelegate
//-------------------------------------------------------------------------------------------------------------------------------------------------

- (void)didSelectSingleUser:(PFUser *)user;

@end

@interface KNSelectSingleView : PFQueryTableViewController

@property (nonatomic, assign)  id<KNSelectSingleDelegate>delegate;

@end
