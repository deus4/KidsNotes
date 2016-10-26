//
//  IKFeedlineTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 03/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKFeedlineTableViewCell.h"

@implementation IKFeedlineTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.likeLabel.font = [UIFont fontWithName:@"Roboto-Light" size:13];
    self.userprofileImage.layer.masksToBounds = YES;
    self.userprofileImage.layer.cornerRadius = 15.0f;
    self.usernameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
