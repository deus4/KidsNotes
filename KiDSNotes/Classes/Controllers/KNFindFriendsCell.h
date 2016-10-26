//
//  KNFindFriendsCell.h
//  KiDSNotes
//
//  Created by deus4 on 16/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>
//KNFindFriendsCellDelegate
@class KNFindFriendsCell;

@protocol KNFindFriendsCellDelegate;

@interface KNFindFriendsCell : PFTableViewCell  {
    id _delegate;
}
@property (nonatomic, strong) id<KNFindFriendsCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet PFImageView *userProfileImage;
@property (nonatomic, strong) PFUser *user;


- (void)setUser:(PFUser *)user;
- (void)didTapFollowButtonAction:(id)sender;
@end

@protocol KNFindFriendsCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(KNFindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser;

@end
