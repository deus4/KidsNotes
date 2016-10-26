//
//  Message.m
//  KiDSNotes
//
//  Created by deus4 on 20/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "Message.h"

@implementation Message

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary objectForKey:@"lastMessage"]) {
            _lastMessage = [dictionary objectForKey:@"lastMessage"];
        }
        if ([dictionary objectForKey:@"userName"]) {
            _userName = [dictionary objectForKey:@"userName"];
        }
        if ([dictionary objectForKey:@"userPhoto"]) {
            _userPhoto = [dictionary objectForKey:@"userPhoto"];
        }
    }
    return self;
}
@end
