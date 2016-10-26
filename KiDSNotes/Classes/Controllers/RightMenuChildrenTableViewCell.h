//
//  RightMenuChildrenTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 11/07/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface RightMenuChildrenTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *childImageView;
@property (strong, nonatomic) IBOutlet UILabel *childNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *rightContentButton;

@end
