//
//  ProfilePhotos.m
//  KiDSNotes
//
//  Created by deus4 on 18/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "ProfilePhotos.h"

@implementation ProfilePhotos

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        //possible to check if dictinoary is not empty
        if ([dictionary objectForKey:@"picture"]) {
            _photos = [dictionary objectForKey:@"picture"];
        }
    }
    return self;
}

@end
