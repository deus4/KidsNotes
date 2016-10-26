//
//  IKFeedlineTableViewController.h
//  KiDSNotes
//
//  Created by deus4 on 03/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKPhotoHeaderView.h" 
#import "IKPhotoCell.h"

@interface IKFeedlineTableViewController : PFQueryTableViewController < IKPhotoCellDelegate, IKPhotoHeaderViewDelegate>
@property(nonatomic, assign) int numberOfPages;

@end
