//
//  FLComments.h
//  KiDSNotes
//
//  Created by deus4 on 02/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLComments : NSObject

@property NSString *comment;
@property NSString *name;
@property NSString *photo;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end

