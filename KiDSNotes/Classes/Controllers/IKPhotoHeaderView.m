//
//  IKPhotoHeaderView.m
//  KiDSNotes
//
//  Created by deus4 on 04/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKPhotoHeaderView.h"
#import "IKProfileImageView.h"
#import "TTTTimeintervalFormatter.h"
#import "PAPUtility.h"

@interface IKPhotoHeaderView ()

@property (nonatomic, strong) IBOutlet IKProfileImageView *avatarImageView;
@property (nonatomic, strong) IBOutlet UIButton *userButton;
@property (nonatomic, strong) IBOutlet UILabel *timestampLabel;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end

@implementation IKPhotoHeaderView
@synthesize containerView;
@synthesize avatarImageView;
@synthesize userButton;
@synthesize timeIntervalFormatter;
@synthesize timestampLabel;
@synthesize photo;
@synthesize buttons;
@synthesize likeButton;
@synthesize commentButton;
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.clipsToBounds = NO;
    self.containerView.clipsToBounds = NO;
    self.superview.clipsToBounds = NO;
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.buttons & IKPhotoHeaderButtonsComment) {
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setBackgroundColor:[UIColor clearColor]];
        [self.commentButton setTitle:@"" forState:UIControlStateNormal];
        [self.commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(-6.0f, 0.0f, 0.0f, 0.0f)];
        [[self.commentButton titleLabel] setFont:[UIFont fontWithName:@"Roboto-Regular" size:13.0f]];
        [[self.commentButton  titleLabel] setMinimumScaleFactor:0.8f];
        [[self.commentButton titleLabel]setAdjustsFontSizeToFitWidth:YES];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentButton"] forState:UIControlStateNormal];
        [self.commentButton setSelected:NO];
    }
    if (self.buttons & IKPhotoHeaderButtonsLike) {
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeButton setBackgroundColor:[UIColor clearColor]];
        [self.likeButton setTitle:@"" forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [[self.likeButton titleLabel] setFont:[UIFont fontWithName:@"Roboto-Regular" size:13.0f]];
        [[self.likeButton titleLabel]setAdjustsFontSizeToFitWidth:YES];
        [self.likeButton setAdjustsImageWhenHighlighted:NO];
        [self.likeButton setAdjustsImageWhenDisabled:NO];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeButtonActive"] forState:UIControlStateSelected];
        [self.likeButton setSelected:NO];
        
    }
    if (self.buttons & IKPhotoHeaderButtonsUser) {
        self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.userButton setBackgroundColor:[UIColor clearColor]];
        [[self.userButton titleLabel]setFont:[UIFont fontWithName:@"Roboto-Regular" size:13.0f]];
        //[self.userButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:159.0f/255.0f blue:232.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [[self.userButton titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc]init];
    
    [self.timestampLabel setTextColor:[UIColor blackColor]];
    [self.timestampLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:10]];
    [self.timestampLabel setBackgroundColor:[UIColor clearColor]];
    self.userButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0f];


}
- (id)initWithFrame:(CGRect )frame buttons:(IKPhotoHeaderButtons)otherButtons  {
    self = [super initWithFrame:frame];
    if (self) {
        [IKPhotoHeaderView validateButtons:otherButtons];
        buttons = otherButtons;
        self.clipsToBounds = NO;
        self.containerView.clipsToBounds = NO;
        self.superview.clipsToBounds = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self.avatarImageView.profileButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.buttons & IKPhotoHeaderButtonsComment) {
            commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.commentButton setBackgroundColor:[UIColor clearColor]];
            [self.commentButton setTitle:@"" forState:UIControlStateNormal];
            [self.commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(-6.0f, 0.0f, 0.0f, 0.0f)];
            [[self.commentButton titleLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0f]];
            [[self.commentButton  titleLabel] setMinimumScaleFactor:0.8f];
            [[self.commentButton titleLabel]setAdjustsFontSizeToFitWidth:YES];
            [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentButton"] forState:UIControlStateNormal];
            [self.commentButton setSelected:NO];
        }
        if (self.buttons & IKPhotoHeaderButtonsLike) {
            likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.likeButton setBackgroundColor:[UIColor clearColor]];
            [self.likeButton setTitle:@"" forState:UIControlStateNormal];
            [self.likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [[self.likeButton titleLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0f]];
            [[self.likeButton titleLabel]setAdjustsFontSizeToFitWidth:YES];
            [self.likeButton setAdjustsImageWhenHighlighted:NO];
            [self.likeButton setAdjustsImageWhenDisabled:NO];
            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeButtonActive"] forState:UIControlStateSelected];
            [self.likeButton setSelected:NO];
            
        }
        if (self.buttons & IKPhotoHeaderButtonsUser) {
            self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.userButton setBackgroundColor:[UIColor clearColor]];
            [[self.userButton titleLabel]setFont:[UIFont fontWithName:@"PingFangTC-Semibold" size:13.0f]];
            [self.userButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:159.0f/255.0f blue:232.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [[self.userButton titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
        }
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc]init];
        
        [self.timestampLabel setTextColor:[UIColor blackColor]];
        [self.timestampLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:10]];
        [self.timestampLabel setBackgroundColor:[UIColor clearColor]];
       
    }
    return self;
}

#pragma mark - IKPhotoHeaderView

- (void)setPhoto:(PFObject *)aPhoto  {
    photo = aPhoto;
    
    PFUser *user = [self.photo objectForKey:@"user"];
    if ([PAPUtility userHasProfilePictures:user]) {
        PFFile *profilePicutreSmall = [user objectForKey:@"profilePictureSmall"];
        [self.avatarImageView setFile:profilePicutreSmall];
    }   else    {
        [self.avatarImageView setImage:[PAPUtility defaultProfilePicture]];
    }
    [self.avatarImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.avatarImageView.layer.cornerRadius = 15.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    NSString *authorName = [user objectForKey:@"displayName"];
    [self.userButton setTitle:authorName forState:UIControlStateNormal];
    
    CGFloat constrainWidth = containerView.bounds.size.width;
    
    if (self.buttons & IKPhotoHeaderButtonsUser) {
        [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.buttons & IKPhotoHeaderButtonsComment) {
        constrainWidth = self.commentButton.frame.origin.x;
         [self.commentButton addTarget:self action:@selector(didTapCommentOnPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.buttons & IKPhotoHeaderButtonsLike) {
        constrainWidth = self.likeButton.frame.origin.x;
        [self.likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGPoint userButtonPoint = CGPointMake(50.0f, 6.0f);
    constrainWidth -= userButtonPoint.x;
    CGSize constrainSize = CGSizeMake(constrainWidth, containerView.bounds.size.height - userButtonPoint.y * 2.0f);
    CGSize userButtonSize = [self.userButton.titleLabel.text boundingRectWithSize:constrainSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.userButton.titleLabel.font} context:nil].size;
    
    CGRect userButtonFrame = CGRectMake(userButtonPoint.x, userButtonPoint.y, userButtonSize.width, userButtonSize.height);
    [self.userButton setFrame:userButtonFrame];
    
    NSTimeInterval timeInterval = [[self.photo createdAt] timeIntervalSinceNow];
    NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
    [self.timestampLabel setText:timestamp];
    
    
    [self setNeedsDisplay];
}

- (void)setLikeStatus:(BOOL)liked {
    [self.likeButton setSelected:liked];
    
    if (liked) {
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(-3.0f, 0.0f, 0.0f, 0.0f)];
    } else {
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(-3.0f, 0.0f, 0.0f, 0.0f)];
    }
}
- (void)shouldEnableLikeButton:(BOOL)enable {
    if (enable) {
        [self.likeButton removeTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

+ (void)validateButtons:(IKPhotoHeaderButtons)buttons   {
    if  (buttons == IKPhotoHeaderButtonsNone)    {
        [NSException raise:NSInvalidArgumentException format:@"Buttons must be set before init header"];
    }
}
- (void)didTapUserButtonAction:(UIButton *)sender   {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapUserButton:user:)]) {
        [delegate photoHeaderView:self didTapUserButton:sender user:[self.photo objectForKey:@"user"]];
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
