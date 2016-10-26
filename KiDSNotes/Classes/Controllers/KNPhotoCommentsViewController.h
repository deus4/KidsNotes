//
//  KNPhotoCommentsViewController.h
//  KiDSNotes
//
//  Created by deus4 on 11/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "KNPhotoCommentCell.h"

@interface KNPhotoCommentsViewController : PFQueryTableViewController
@property (nonatomic, strong) PFObject *photo;

@end
