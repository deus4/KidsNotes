//
//  MessageTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 20/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *lastMessage;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageTime;

@end
