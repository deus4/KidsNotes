//
//  IKKNAccountViewController.h
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKKNAccountViewController : UIViewController

@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *publishCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *subscribersCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *subsCountLabel;

@end
