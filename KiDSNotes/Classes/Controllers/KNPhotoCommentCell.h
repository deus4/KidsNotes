//
//  KNPhotoCommentCell.h
//  KiDSNotes
//
//  Created by deus4 on 11/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface KNPhotoCommentCell : PFTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet PFImageView *userProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *timeStampLabel;

@end
