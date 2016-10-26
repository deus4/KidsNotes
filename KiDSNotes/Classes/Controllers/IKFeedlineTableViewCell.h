//
//  IKFeedlineTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 03/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKFeedlineTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userprofileImage;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@end
