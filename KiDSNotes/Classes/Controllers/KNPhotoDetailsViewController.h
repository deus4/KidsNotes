//
//  KNPhotoDetailsViewController.h
//  KiDSNotes
//
//  Created by deus4 on 07/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "KNPhotoCommentViewController.h"

@interface KNPhotoDetailsViewController : PFQueryTableViewController
@property (nonatomic, strong) PFObject *photo;
@end
