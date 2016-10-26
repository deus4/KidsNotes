//
//  FirstDaysTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 23/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "FirstDaysTableViewCell.h"
#import "UIView+Fonts.h"

@implementation FirstDaysTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.userNameLabel setKidsProGradeFiveFont];
    [self.timeStampLabel setKidsProGradeOneFont];
    [self.headerLabel setKidsProGradeFiveFont];
    [self.postTextlabel setKidsProGradeFiveFont];
    [self.postLikesLabel setKidsProGradeOneFont];
    [self.postRepliesLabel setKidsProGradeOneFont];
    [self.viewLabel setKidsProGradeOneFont];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
