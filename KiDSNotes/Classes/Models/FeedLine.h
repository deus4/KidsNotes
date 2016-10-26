//
//  FeedLine.h
//  KiDSNotes
//
//  Created by deus4 on 02/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedLine : NSObject

@property (strong, nonatomic) NSDate *dateTime;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *postPhoto;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSString *userPhoto;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
