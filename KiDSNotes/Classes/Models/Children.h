//
//  Children.h
//  KiDSNotes
//
//  Created by deus4 on 27/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Children : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *picture;

-(id)initWithDictionary:(NSDictionary *)dictinoary;

@end
