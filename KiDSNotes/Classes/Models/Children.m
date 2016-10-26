//
//  Children.m
//  KiDSNotes
//
//  Created by deus4 on 27/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "Children.h"

@implementation Children

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        //possible to check if dictinoary is not empty
        if ([dictionary objectForKey:@"name"]) {
            _name = [dictionary objectForKey:@"name"];
        }
        if ([dictionary objectForKey:@"age"]) {
            _age = [dictionary objectForKey:@"age"];
        }
        if ([dictionary objectForKey:@"picture"]) {
            _picture = [dictionary objectForKey:@"picture"];
        }
    }
    return self;
}

@end
