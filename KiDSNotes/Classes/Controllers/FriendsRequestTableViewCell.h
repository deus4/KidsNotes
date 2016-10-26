//
//  FriendsRequestTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 29/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsRequestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *commonFriends;

@end
