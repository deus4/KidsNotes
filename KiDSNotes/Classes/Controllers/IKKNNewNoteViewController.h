//
//  IKKNNewNoteViewController.h
//  KiDSNotes
//
//  Created by deus4 on 24/03/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKKNNewNoteViewController : UIViewController
@property (nonatomic, nonnull) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, nonnull) PFObject *children;

@end
