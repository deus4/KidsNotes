//
//  KNSelectSingleCell.h
//  KiDSNotes
//
//  Created by deus4 on 21/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface KNSelectSingleCell : PFTableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@end
