//
//  IKKNNoteDetailViewController.h
//  KiDSNotes
//
//  Created by deus4 on 24/03/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNNote.h"
@interface IKKNNoteDetailViewController : UIViewController

@property (nonatomic,strong) KNNote *note;
@property (nonatomic, nonnull) PFObject *noteObject;
@end
