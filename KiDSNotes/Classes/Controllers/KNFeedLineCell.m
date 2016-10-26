//
//  KNFeedLineCell.m
//  KiDSNotes
//
//  Created by deus4 on 03/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNFeedLineCell.h"
#import <ParseUI/ParseUI.h>
#import "Parse.h"
#import "PAPCache.h"
#import "PAPUtility.h"
#import "TTTTimeIntervalFormatter.h"
#import "NonClippingLabel.h"

@interface KNFeedLineCell ()
@property (strong, nonatomic) IBOutlet UIButton *userButton;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@end
@implementation KNFeedLineCell
@synthesize userButton;
@synthesize likeButton;
@synthesize photographer;
@synthesize photo;
@synthesize delegate;
@synthesize timeIntervalFormatter;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
     [self.likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];

    [self.userButton setTitle:nil forState:UIControlStateNormal];
    // Initialization code
}

-(void)setPhoto:(PFObject *)aPhoto  {
    photo = aPhoto;
    
    PFUser *user = [self.photo objectForKey:@"user"];
    
    if ([PAPUtility userHasProfilePictures:user]) {
        PFFile *profilePictureSmall = [user objectForKey:@"profilePicture"];
        [self.userPhoto setFile:profilePictureSmall];
        [self.userPhoto loadInBackground];
    } else {
        [self.userPhoto setImage:[PAPUtility defaultProfilePicture]];
    }
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.width / 2;
    self.userPhoto.layer.masksToBounds = YES;
    NSString *firstName = user[@"firstName"];
    NSString *lastName = user[@"lastName"];
    NSString *qandaString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];

    self.userNameLabel.text = qandaString;

    NSString *photoComment = photo[@"photoComment"];
    
    self.postComment.text = photoComment;

    NSTimeInterval timeInterval = [[self.photo createdAt] timeIntervalSinceNow];
    NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
    [self.timeStamp setText:timestamp];
  
    PFFile *postPhotoFile = [self.photo objectForKey:@"image"];
    [self.postPhoto setFile:postPhotoFile];
    [self.postPhoto loadInBackground];
    
    [self setNeedsDisplay];
}

- (void)setLikeStatus:(BOOL)liked {
    [self.likeButton setSelected:liked];
    
    if (liked) {
        
        [self.likeButton setImage:[UIImage imageNamed:@"likeIconHighlited"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"likeIcon"] forState:UIControlStateNormal];
    }
}

- (void)shouldEnableLikeButton:(BOOL)enable {
    if (enable) {
        [self.likeButton removeTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else  {
        [self.likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)didTapUserButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapUserButton:user:)]) {
        [delegate photoHeaderView:self didTapUserButton:sender user:[self.photo objectForKey:kPAPPhotoUserKey]];
    }
}

- (void)didTapLikePhotoButtonAction:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapLikePhotoButton:photo:)]) {
        [delegate photoHeaderView:self didTapLikePhotoButton:button photo:self.photo];
    }
}
@end
