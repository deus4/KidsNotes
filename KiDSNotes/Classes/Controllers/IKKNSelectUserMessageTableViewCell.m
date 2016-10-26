//
//  IKKNSelectUserMessageTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 01/07/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNSelectUserMessageTableViewCell.h"

@implementation IKKNSelectUserMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userProfileImageView.layer.cornerRadius = 20.0f;
    self.userProfileImageView.layer.masksToBounds = true;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
