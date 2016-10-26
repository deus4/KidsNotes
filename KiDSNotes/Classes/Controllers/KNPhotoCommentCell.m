//
//  KNPhotoCommentCell.m
//  KiDSNotes
//
//  Created by deus4 on 11/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNPhotoCommentCell.h"
#import "UIView+Fonts.h"

@implementation KNPhotoCommentCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)prepareForInterfaceBuilder  {
    [super prepareForInterfaceBuilder];
    self.userNameLabel.text = nil;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    self.userNameLabel.text = nil;
  

}

@end
