//
//  FirstDaysTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 23/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstDaysTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTextlabel;
@property (weak, nonatomic) IBOutlet UILabel *postLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *postRepliesLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;

@end
