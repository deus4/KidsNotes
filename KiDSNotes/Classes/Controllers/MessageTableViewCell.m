//
//  MessageTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 20/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "UIView+Fonts.h"
@implementation MessageTableViewCell

- (void)awakeFromNib {
    [self.userName setKidsProGradeFiveFont];
    [self.lastMessage setKidsProGradeFiveFont];
    [self.lastMessageTime setKidsProGradeOneFont];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
