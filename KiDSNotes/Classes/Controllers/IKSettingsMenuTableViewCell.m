//
//  IKSettingsMenuTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 14/07/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKSettingsMenuTableViewCell.h"

@implementation IKSettingsMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]]; // set color here
    [self setSelectedBackgroundView:selectedBackgroundView];
    // Configure the view for the selected state
}

@end
