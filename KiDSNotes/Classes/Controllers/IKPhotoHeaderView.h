//
//  IKPhotoHeaderView.h
//  KiDSNotes
//
//  Created by deus4 on 04/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    IKPhotoHeaderButtonsNone = 0,
    IKPhotoHeaderButtonsLike = 1 << 0,
    IKPhotoHeaderButtonsComment = 1 << 1,
    IKPhotoHeaderButtonsUser = 1 << 2,
    
    IKPhotoHeaderButtonsDefault = IKPhotoHeaderButtonsLike | IKPhotoHeaderButtonsComment | IKPhotoHeaderButtonsUser
    
} IKPhotoHeaderButtons;

@protocol IKPhotoHeaderViewDelegate;

@interface IKPhotoHeaderView : UITableViewCell
/*! @name Creating Photo Header View */
/*!
 Initializes the view with the specified interaction elements.
 @param buttons A bitmask specifying the interaction elements which are enabled in the view
 */

// The photo associated with this view
@property (nonatomic , strong) PFObject *photo;
/// The bitmask which specifies the enabled interaction elements in the view
@property (nonatomic, readonly, assign) IKPhotoHeaderButtons buttons;
@property (nonatomic) IBOutlet UIButton *likeButton;
@property (nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, weak) id <IKPhotoHeaderViewDelegate> delegate;

- (void)setLikeStatus:(BOOL)liked;

- (void)shouldEnableLikeButton:(BOOL)enable;

@end

@protocol IKPhotoHeaderViewDelegate <NSObject>
@optional

- (void)photoHeaderView:(IKPhotoHeaderView *)photoHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user;

- (void)photoHeaderView:(IKPhotoHeaderView *)photoHeaderView didTapLikePhotoButton:(UIButton *)button photo:(PFObject *)photo;
- (void)photoHeaderView:(IKPhotoHeaderView *)photoHeaderView didTapCommentOnPhotoButton:(UIButton *)button photo:(PFObject *)photo;

@end