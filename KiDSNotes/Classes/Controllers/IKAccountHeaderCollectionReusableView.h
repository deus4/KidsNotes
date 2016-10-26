//
//  IKAccountHeaderCollectionReusableView.h
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKAccountHeaderCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *publishCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *subscribersCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *subsCountLabel;
@property (strong, nonatomic) IBOutlet PFImageView *firstChildImageView;
@property (strong, nonatomic) IBOutlet PFImageView *secondChildImageView;
@property (strong, nonatomic) IBOutlet PFImageView *thirdChildImageView;
@property (strong, nonatomic) IBOutlet PFImageView *fourthChildImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstChildLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondChildLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdChildLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourthChildLabel;


@end
