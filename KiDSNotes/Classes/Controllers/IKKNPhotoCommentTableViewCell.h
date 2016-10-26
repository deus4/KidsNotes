//
//  IKKNPhotoCommentTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 10/05/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IKProfileImageView;
@protocol IKKNPhotoCommentCellDelegate;

@interface IKKNPhotoCommentTableViewCell : UITableViewCell {
    id _delegate;
}
@property (nonatomic, strong) id delegate;
/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *nameButton;
@property (strong, nonatomic) IBOutlet IKProfileImageView *avatarImageView;

- (void)setDate:(NSDate *)date;

@end
/*!
 The protocol defines methods a delegate of a IKKNPhotoCommentCellDelegate should implement.
 */
@protocol IKKNPhotoCommentCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(IKKNPhotoCommentTableViewCell *)cellView didTapUserButton:(PFUser *)aUser;

@end
