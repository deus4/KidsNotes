//
//  DataManager.h
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Menu.h"
#import "Children.h"
#import "FeedLine.h"
#import "ProfilePhotos.h"
#import "Message.h"

#define DATA [DataManager dataManager]

@interface DataManager : NSObject

@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSArray *childrenItems;
@property (strong, nonatomic) NSArray *feedLine;
@property (strong, nonatomic) NSArray *profilePhotos;
@property (strong, nonatomic) NSArray *messages;
+(DataManager *)dataManager;

@end
