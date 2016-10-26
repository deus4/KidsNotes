//
//  Message.h
//  KiDSNotes
//
//  Created by deus4 on 20/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property NSString *lastMessage;
@property NSString *userPhoto;
@property NSString *userName;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
