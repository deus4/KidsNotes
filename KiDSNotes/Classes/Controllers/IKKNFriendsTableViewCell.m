//
//  IKKNFriendsTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 18/04/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNFriendsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation IKKNFriendsTableViewCell
@synthesize delegate;
@synthesize user;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    [[self.followButton layer] setBorderWidth:1.0f];
    [[self.followButton layer] setBorderColor:UIColorFromRGB(0xDFDCDF).CGColor];
    self.followButton.layer.cornerRadius = 3;
    self.userImageView.layer.cornerRadius = 22.5;
    self.userImageView.layer.masksToBounds = YES;
    [self.followButton setTitle:@"отписаться"
                       forState:UIControlStateSelected];
    [self.followButton addTarget:self action:@selector(didTapFollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark - IKKNFriendsTableViewCell

- (void)setUser:(PFUser *)aUser {
    user = aUser;
    // Configure the cell
    if ([PAPUtility userHasProfilePictures:self.user]) {
        [self.userImageView setFile:[self.user objectForKey:kPAPUserProfilePicSmallKey]];
    } else {
        [self.userImageView setImage:[PAPUtility defaultProfilePicture]];
    }
    
   // [self.userImageView loadInBackground];
    NSString *nameString = [self.user objectForKey:kPAPUserDisplayNameKey];
    self.userNameLabel.text = nameString;
}

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:self didTapUserButton:self.user];
    }
}

/* Inform delegate that the follow button was tapped */
- (void)didTapFollowButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapFollowButton:)]) {
        [self.delegate cell:self didTapFollowButton:self.user];
    }
}

@end
