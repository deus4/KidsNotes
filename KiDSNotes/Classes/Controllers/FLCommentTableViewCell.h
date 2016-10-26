//
//  FLCommentTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 11/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;

@end
