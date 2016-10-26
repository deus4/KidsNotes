//
//  IKAccountCollectionViewController.h
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "IKFeedlineTableViewController.h"
#import "IKPhotoTimelineViewController.h"

@interface IKAccountCollectionViewController : IKFeedlineTableViewController <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) PFUser *user;


@end
