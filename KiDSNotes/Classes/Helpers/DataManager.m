//
//  DataManager.m
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+(DataManager *)dataManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc]init];
    });
    return _sharedObject;
}
-(id)init {
    self = [super init];
    if (self) {
        //Init menu items
        _menuItems = [NSArray arrayWithArray:[self arrayFromPlistWithName:@"menu" withItemClass:[Menu class]]];
        _childrenItems = [NSArray arrayWithArray:[self arrayFromPlistWithName:@"childrens" withItemClass:[Children class]]];
        _feedLine = [NSArray arrayWithArray:[self arrayFromPlistWithName:@"feedLine" withItemClass:[FeedLine class]]];
        _profilePhotos = [NSArray arrayWithArray:[self arrayFromPlistWithName:@"profilePhotos" withItemClass:[ProfilePhotos class]]];
        _messages = [NSArray arrayWithArray:[self arrayFromPlistWithName:@"messages" withItemClass:[Message class]]];
    }
    return self;
}

- (NSMutableArray *) arrayFromPlistWithName:(NSString *)plistName withItemClass: (Class) class{
    NSMutableArray *temp = [NSMutableArray array];
    NSArray* plist = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
    
    for (NSDictionary *dic in plist) {
        [temp addObject:[[class alloc] initWithDictionary:dic]];
    }
    
    return temp;
}

@end
