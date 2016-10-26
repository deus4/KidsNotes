//
//  IKKNNotesViewController.h
//  KiDSNotes
//
//  Created by deus4 on 24/03/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface IKKNNotesViewController : ViewController

@property (nonatomic, nonnull) NSManagedObjectContext *managedObjectContext;
@property (nonnull ,nonatomic) PFObject *children;
@end
