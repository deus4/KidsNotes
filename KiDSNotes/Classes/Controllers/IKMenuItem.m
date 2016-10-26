//
//  IKMenuItem.m
//  KiDSNotes
//
//  Created by deus4 on 01/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKMenuItem.h"

@implementation IKMenuItem

- (instancetype)initWithTitle:(NSString *)title
                         icon:(NSString *)icon
                       itemId:(IKMenuItemId)itemId
{
    self = [super init];
    if (self) {
        _title = title;
        _icon = [UIImage imageNamed:icon];
        _itemId = itemId;
    }
    return self;
}

@end
