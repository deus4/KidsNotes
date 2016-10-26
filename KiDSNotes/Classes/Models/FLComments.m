//
//  FLComments.m
//  KiDSNotes
//
//  Created by deus4 on 02/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "FLComments.h"

@implementation FLComments

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary objectForKey:@"comment"]) {
            _comment = [dictionary objectForKey:@"comment"];
        }
        if ([dictionary objectForKey:@"name"]) {
            _name = [dictionary objectForKey:@"name"];
        }
        if ([dictionary objectForKey:@"photo"]) {
            _photo = [dictionary objectForKey:@"photo"];
        }
    }
    return self;
}
@end
