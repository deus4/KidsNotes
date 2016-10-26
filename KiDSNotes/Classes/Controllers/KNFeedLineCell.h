//
//  KNFeedLineCell.h
//  KiDSNotes
//
//  Created by deus4 on 03/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>
@class KNFeedLineCell;

@protocol KNFeedLineCellDelegate;

@interface KNFeedLineCell : PFTableViewCell {
    id _delegate;
}


@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet PFImageView *userPhoto;
@property (strong, nonatomic) IBOutlet PFImageView *postPhoto;
@property (strong, nonatomic) IBOutlet UILabel *postComment;
@property (strong, nonatomic) IBOutlet UILabel *commentNumber;
@property (strong, nonatomic) IBOutlet UILabel *likeNumber;
@property (strong, nonatomic) IBOutlet UILabel *timeStamp;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
/// The user that took the photo
@property (nonatomic, strong) PFUser *photographer;
/// The photo displayed in the view
@property (nonatomic,strong) PFObject *photo;
/// Array of the users that liked the photo
@property (nonatomic, strong) NSArray *likeUsers;
/*! @name Delegate */
@property (nonatomic, strong) id<KNFeedLineCellDelegate> delegate;

- (void)setLikeStatus:(BOOL)liked;
/*!
Enable the like button to start receiving actions.
@param enable a BOOL indicating if the like button should be enabled.
*/
- (void)shouldEnableLikeButton:(BOOL)enable;
- (void)didTapLikePhotoButtonAction:(id)sender;

@end
@protocol KNFeedLineCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)photoHeaderView:(KNFeedLineCell *)photoHeaderView didTapLikePhotoButton:(UIButton *)button photo:(PFObject *)photo;
/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoHeaderView:(KNFeedLineCell *)photoHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user;

@end