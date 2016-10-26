//
//  NonClippingLabel.m
//  KiDSNotes
//
//  Created by deus4 on 14/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "NonClippingLabel.h"

@implementation NonClippingLabel

#define GUTTER 4.0f // make this large enough to accommodate the largest font in your app

- (void)drawRect:(CGRect)rect
{
    // fixes word wrapping issue
    CGRect newRect = rect;
    newRect.origin.x = rect.origin.x + GUTTER;
    newRect.size.width = rect.size.width - 2 * GUTTER;
    [self.attributedText drawInRect:newRect];
}

- (UIEdgeInsets)alignmentRectInsets
{
    return UIEdgeInsetsMake(0, GUTTER, 0, GUTTER);
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width += 2 * GUTTER;
    return size;
}
-(CGSize)sizeThatFits:(CGSize)size {
    CGSize size_ = [super sizeThatFits:size];
    size_.width += 2 * GUTTER;
    return size_; }

@end
