//
//  IKMenuItem.h
//  KiDSNotes
//
//  Created by deus4 on 01/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IKMenuItemId) {
    IK_MENU_ITEM_PROFILE,
    IK_MENU_ITEM_FEED,
    IK_MENU_ITEM_FRIENDS,
    IK_MENU_ITEM_KIDS,
    IK_MENU_ITEM_MESSAGES,
    IK_MENU_ITEM_SETTINGS,
    
};

@interface IKMenuItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) IKMenuItemId itemId;


- (instancetype)initWithTitle:(NSString *)title
                         icon:(NSString *)icon
                       itemId:(IKMenuItemId)itemId;

@end
