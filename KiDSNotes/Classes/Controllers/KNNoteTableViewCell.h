//
//  KNNoteTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 25/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNNote;

@interface KNNoteTableViewCell : UITableViewCell

- (void)configureWithNote:(KNNote *)note;

@end
