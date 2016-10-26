//
//  Menu.m
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "Menu.h"

@implementation Menu

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        //possible to check if dictinoary is not empty
        if ([dictionary objectForKey:@"icon"]) {
            _icon = [dictionary objectForKey:@"icon"];
        }
        if ([dictionary objectForKey:@"title"]) {
            _title = [dictionary objectForKey:@"title"];
        }
        if ([dictionary objectForKey:@"menuId"]) {
            _menuId = [dictionary objectForKey:@"menuId"];
        }
    }
    return self;
}

@end
