//
//  IKSettingsMenuTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 14/07/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKSettingsMenuTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *settingsImageView;
@property (strong, nonatomic) IBOutlet UILabel *settingsLabel;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet UISwitch *settingsSwitch;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;

@end
