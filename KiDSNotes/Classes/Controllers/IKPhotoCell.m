//
//  IKPhotoCell.m
//  KiDSNotes
//
//  Created by deus4 on 04/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKPhotoCell.h"
#import "PAPUtility.h"

@implementation IKPhotoCell

@synthesize buttons;
@synthesize commentButton;
@synthesize likeLabel;
@synthesize likeButton;
@synthesize delegate;
@synthesize photo;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithCoder:(NSCoder *)aDecoder buttons:(IKPhotoCellButtons)otherButtons   {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        [self.likeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0f]];
        [self.commentLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0f]];
        [self.commentTextLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12.0f]];
        
        if (self.buttons & IKPhotoCellButtonsComment) {
            commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.commentButton setBackgroundColor:[UIColor clearColor]];
            [self.commentButton setTitle:nil forState:UIControlStateNormal];
            [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentButton"] forState:UIControlStateNormal];
            [self.commentButton setSelected:NO];
        }
        if (self.buttons & IKPhotoCellButtonsLike) {
            likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.likeButton setBackgroundColor:[UIColor clearColor]];
            [self.likeButton setTitle:nil forState:UIControlStateNormal];
            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeButtonActive"] forState:UIControlStateSelected];
            [self.likeButton setSelected:NO];
            
        }
    }
    return self;
}
- (void)awakeFromNib    {
    [super awakeFromNib];
    
    //self.buttons = IKPhotoCellButtonsDefault;
    self.opaque = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    [self.likeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0f]];
    [self.commentLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0f]];
    [self.commentTextLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12.0f]];
    
    if (self.buttons & IKPhotoCellButtonsComment) {
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setBackgroundColor:[UIColor clearColor]];
        [self.commentButton setTitle:nil forState:UIControlStateNormal];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentButton"] forState:UIControlStateNormal];
        [self.commentButton setSelected:NO];
    }
    if (self.buttons & IKPhotoCellButtonsLike) {
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeButton setBackgroundColor:[UIColor clearColor]];
        [self.likeButton setTitle:nil forState:UIControlStateNormal];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeButtonActive"] forState:UIControlStateSelected];
        [self.likeButton setSelected:NO];
        
    }
    [self.likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(didTapCommentOnPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton addTarget:self action:@selector(didTapSettingsOnPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)shouldEnableLikeButton:(BOOL)enable {
    if (enable) {
        [self.likeButton removeTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

+ (void)validateButtons:(IKPhotoCellButtons)buttons   {
    if  (buttons == IKPhotoCellButtonsNone)    {
        [NSException raise:NSInvalidArgumentException format:@"Buttons must be set before init header"];
    }
}
- (void)didTapLikePhotoButtonAction:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapLikePhotoButton:photo:)]) {
        [delegate photoHeaderView:self didTapLikePhotoButton:button photo:self.photo];
    }
}

- (void)didTapCommentOnPhotoButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapCommentOnPhotoButton:photo:)]) {
        [delegate photoHeaderView:self didTapCommentOnPhotoButton:sender photo:self.photo];
    }
}
- (void)didTapSettingsOnPhotoButton:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapSettingsOnPhotoButton:photo:)]) {
        [delegate photoHeaderView:self didTapSettingsOnPhotoButton:sender photo:self.photo];
    }
}
- (void)setLikeStatus:(BOOL)liked {
    [self.likeButton setSelected:liked];
    
    if (liked) {
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(-3.0f, 0.0f, 0.0f, 0.0f)];
    } else {
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(-3.0f, 0.0f, 0.0f, 0.0f)];
    }
}


@end
