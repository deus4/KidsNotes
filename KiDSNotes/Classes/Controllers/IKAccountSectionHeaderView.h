//
//  IKAccountSectionHeaderView.h
//  KiDSNotes
//
//  Created by deus4 on 25/04/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
@interface IKAccountSectionHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *userDisplayNameLabel;

@end
