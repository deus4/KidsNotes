//
//  IKMenuTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 01/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKMenuTableViewCell : UITableViewCell
@property (nonatomic, assign) NSUInteger itemId;
@property (strong, nonatomic) IBOutlet UIImageView *menuIconButton;
@property (strong, nonatomic) IBOutlet UILabel *menuTextLabel;

@end
