//
//  KNFindFriendsCell.m
//  KiDSNotes
//
//  Created by deus4 on 16/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNFindFriendsCell.h"
#import "PAPUtility.h"
#import "UIView+Fonts.h"

@interface KNFindFriendsCell ()


@end
@implementation KNFindFriendsCell
@synthesize followButton;
@synthesize user;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.followButton addTarget:self action:@selector(didTapFollowButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUser:(PFUser *)aUser {
    user = aUser;
    
    // Configure the cell
    if ([PAPUtility userHasProfilePictures:self.user]) {
        [self.userProfileImage setFile:[self.user objectForKey:@"profilePicture"]];
    } else {
        [self.userProfileImage setImage:[PAPUtility defaultProfilePicture]];
    }
    [self.userProfileImage loadInBackground];
    NSString *firstName = self.user[@"firstName"];
    NSString *lastName = self.user[@"lastName"];
    NSString *qandaString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    self.userNameLabel.text = qandaString;
    self.userProfileImage.layer.cornerRadius = 27;
    self.userProfileImage.layer.masksToBounds = YES;
}

/* Inform delegate that the follow button was tapped */
- (void)didTapFollowButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapFollowButton:)]) {
        [self.delegate cell:self didTapFollowButton:self.user];
    }
}
@end
