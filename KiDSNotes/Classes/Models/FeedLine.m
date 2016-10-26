//
//  FeedLine.m
//  KiDSNotes
//
//  Created by deus4 on 02/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "FeedLine.h"
#import "FLComments.h"

@implementation FeedLine

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary objectForKey:@"date"]) {
            _dateTime = [dictionary objectForKey:@"date"];
        }
        if ([dictionary objectForKey:@"comment"]) {
            _comment = [dictionary objectForKey:@"comment"];
        }
        if ([dictionary objectForKey:@"username"]) {
            _userName = [dictionary objectForKey:@"username"];
        }
        if ([dictionary objectForKey:@"postPhoto"]) {
            _postPhoto = [dictionary objectForKey:@"postPhoto"];
        }
        if ([dictionary objectForKey:@"comments"]) {
            NSArray *temp= [dictionary objectForKey:@"comments"];
            if (temp) {
                NSMutableArray *comments = [NSMutableArray array];
                [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    FLComments *item = [[FLComments alloc]initWithDictionary:obj];
                    [comments addObject:item];
                }];
                _comments = [NSArray arrayWithArray:comments];
            }
        }
        if ([dictionary objectForKey:@"userPhoto"]) {
            _userPhoto = [dictionary objectForKey:@"userPhoto"];
        }
    }
    return self;
}

@end
