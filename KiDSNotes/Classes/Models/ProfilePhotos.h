//
//  ProfilePhotos.h
//  KiDSNotes
//
//  Created by deus4 on 18/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfilePhotos : NSObject

@property (strong, nonatomic) NSString *photos;

-(id)initWithDictionary:(NSDictionary *)dictinoary;

@end
