//
//  IKPhotoCell.h
//  KiDSNotes
//
//  Created by deus4 on 04/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@class PFImageView;

typedef enum {
    IKPhotoCellButtonsNone = 0,
    IKPhotoCellButtonsLike = 1 << 0,
    IKPhotoCellButtonsComment = 1 << 1,
    
    IKPhotoCellButtonsDefault = IKPhotoCellButtonsLike | IKPhotoCellButtonsComment
    
} IKPhotoCellButtons;

@protocol IKPhotoCellDelegate;



@interface IKPhotoCell : PFTableViewCell


@property (nonatomic, strong) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet PFImageView *photoImage;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
// The bitmask which specifies the enabled interaction elements in the view
@property (nonatomic, assign) IKPhotoCellButtons buttons;
@property (nonatomic, weak) id <IKPhotoCellDelegate> delegate;
@property (nonatomic , strong) PFObject *photo;
- (void)setLikeStatus:(BOOL)liked;
- (void)shouldEnableLikeButton:(BOOL)enable;

@end

@protocol IKPhotoCellDelegate <NSObject>

@optional

- (void)photoHeaderView:(IKPhotoCell *)photoHeaderView didTapLikePhotoButton:(UIButton *)button photo:(PFObject *)photo;
- (void)photoHeaderView:(IKPhotoCell *)photoHeaderView didTapCommentOnPhotoButton:(UIButton *)button photo:(PFObject *)photo;
- (void)photoHeaderView:(IKPhotoCell *)photoHeaderView didTapSettingsOnPhotoButton:(UIButton *)button photo:(PFObject *)photo;

@end