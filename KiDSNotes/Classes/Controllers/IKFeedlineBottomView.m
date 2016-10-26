//
//  IKFeedlineBottomView.m
//  KiDSNotes
//
//  Created by deus4 on 29/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKFeedlineBottomView.h"

@implementation IKFeedlineBottomView
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    [self prefix_addUpperBorder];
}
- (void)prefix_addUpperBorder
{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = UIColorFromRGB(0xDDDBDE).CGColor;
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 2.0f);
    [self.layer addSublayer:upperBorder];
}
@end
