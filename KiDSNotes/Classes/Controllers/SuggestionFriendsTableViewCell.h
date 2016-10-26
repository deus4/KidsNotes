//
//  suggestionFriendsTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 16/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionFriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileCommonFriends;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@end
