//
//  MenuTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic, assign) NSUInteger itemId;

@end
