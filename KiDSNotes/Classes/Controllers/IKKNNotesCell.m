//
//  IKKNNotesCell.m
//  KiDSNotes
//
//  Created by deus4 on 07/04/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNNotesCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation IKKNNotesCell


-(void)awakeFromNib {
    [super awakeFromNib];
}
@end
