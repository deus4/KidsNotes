//
//  KNSelectSingleCell.m
//  KiDSNotes
//
//  Created by deus4 on 21/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "KNSelectSingleCell.h"
#import <Parse/Parse.h>

@interface KNSelectSingleCell ()
@end

@implementation KNSelectSingleCell
@synthesize userImage;
@synthesize labelUserName;

- (void)awakeFromNib    {
    self.userImage.layer.cornerRadius = 25;
    self.userImage.layer.masksToBounds = YES;
}

@end
