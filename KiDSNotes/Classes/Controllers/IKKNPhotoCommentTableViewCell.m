//
//  IKKNPhotoCommentTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 10/05/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNPhotoCommentTableViewCell.h"
#import "IKProfileImageView.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation IKKNPhotoCommentTableViewCell
@synthesize user;
@synthesize avatarImageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (!timeFormatter) {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    // Initialization code
    [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.avatarImageView.layer.cornerRadius = 15.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    self.nameButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Delegate methods

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:self didTapUserButton:self.user];
    }
}
- (void)setUser:(PFUser *)aUser {
    user = aUser;
    // Set name button properties and avatar image
    if ([PAPUtility userHasProfilePictures:self.user]) {
        [self.avatarImageView setFile:[self.user objectForKey:kPAPUserProfilePicSmallKey]];
    } else {
        [self.avatarImageView setImage:[PAPUtility defaultProfilePicture]];
    }
    [self.nameButton setTitle:[self.user objectForKey:kPAPUserDisplayNameKey] forState:UIControlStateNormal];
    [self.nameButton setTitle:[self.user objectForKey:kPAPUserDisplayNameKey] forState:UIControlStateHighlighted];
    [self setNeedsDisplay];
}
- (void)setDate:(NSDate *)date {
    // Set the label with a human readable time
    [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date]];
    [self setNeedsDisplay];
}
@end
