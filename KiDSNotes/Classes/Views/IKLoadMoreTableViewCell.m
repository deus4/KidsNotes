//
//  IKLoadMoreTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKLoadMoreTableViewCell.h"

@implementation IKLoadMoreTableViewCell
@synthesize cellInsetWidth;
@synthesize mainView;
@synthesize separatorImageTop;
@synthesize separatorImageBottom;
@synthesize loadMoreImageView;
@synthesize hideSeparatorTop;
@synthesize hideSeparatorBottom;

- (void)awakeFromNib {
    // Initialization code
    self.cellInsetWidth = 0.0f;
    hideSeparatorTop = NO;
    hideSeparatorBottom = NO;
    
    self.opaque = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
