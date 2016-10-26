//
//  KNPhotoDetailsCommentCell.m
//  KiDSNotes
//
//  Created by deus4 on 09/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNPhotoDetailsCommentCell.h"
#import "UIView+Fonts.h"

@implementation KNPhotoDetailsCommentCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    self.userName.text = @"SHOW ME";
    [self.userName setKidsProGradeFiveFont];
    [self.userComment setKidsProGradeFiveFont];
    // Initialization code
}


@end
