//
//  IKMenuTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 01/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKMenuTableViewCell.h"

@implementation IKMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.menuTextLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
