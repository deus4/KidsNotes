//
//  KNPhotoDetailsCommentCell.h
//  KiDSNotes
//
//  Created by deus4 on 09/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface KNPhotoDetailsCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *userPhoto;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userComment;

@end
