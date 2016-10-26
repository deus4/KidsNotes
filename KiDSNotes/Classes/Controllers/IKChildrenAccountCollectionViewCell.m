//
//  IKChildrenAccountCollectionViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKChildrenAccountCollectionViewCell.h"

@implementation IKChildrenAccountCollectionViewCell

- (void)awakeFromNib    {
    [super awakeFromNib];
    self.childrenName.font = [UIFont fontWithName:@"Roboto-Light" size:10.0f];
    self.childrenImage.layer.masksToBounds = YES;
    self.childrenImage.layer.cornerRadius = 25.0f;
}
@end
