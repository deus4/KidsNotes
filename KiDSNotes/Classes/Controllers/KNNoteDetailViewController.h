//
//  KNNoteDetailViewController.h
//  KiDSNotes
//
//  Created by deus4 on 26/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "ViewController.h"
#import "KNNote.h"

@interface KNNoteDetailViewController : UIViewController
@property (strong,nonatomic) KNNote *selectedNote;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end
