//
//  IKKNFriendsTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 18/04/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>
@protocol IKKNFriendsCellDelegate;
@interface IKKNFriendsTableViewCell : PFTableViewCell {
    id _delegate;
}
@property (nonatomic, strong) id<IKKNFriendsCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet PFImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) PFUser *user;
/*! Setters for the cell's content */
- (void)setUser:(PFUser *)user;
- (void)didTapUserButtonAction:(id)sender;
- (void)didTapFollowButtonAction:(id)sender;
/*!
 The protocol defines methods a delegate of a PAPFindFriendsCell should implement.
 */
@end
@protocol IKKNFriendsCellDelegate <NSObject>
/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(IKKNFriendsTableViewCell *)cellView didTapUserButton:(PFUser *)aUser;
- (void)cell:(IKKNFriendsTableViewCell *)cellView didTapFollowButton:(PFUser *)aUser;
@end
