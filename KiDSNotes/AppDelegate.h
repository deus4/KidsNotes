//
//  AppDelegate.h
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "KNRecentMessagesViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) int networkStatus;
- (BOOL)isParseReachable;

@property (nonatomic, strong) KNRecentMessagesViewController *recentView;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


- (void)logOut;
- (void)autoFollowUsers;

@end

