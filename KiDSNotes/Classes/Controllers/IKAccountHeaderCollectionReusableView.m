//
//  IKAccountHeaderCollectionReusableView.m
//  KiDSNotes
//
//  Created by deus4 on 10/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKAccountHeaderCollectionReusableView.h"

@interface IKAccountHeaderCollectionReusableView ()


@end

@implementation IKAccountHeaderCollectionReusableView


-(void)awakeFromNib {
    [super awakeFromNib];
    self.userNameLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0f];
    self.cityLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12.0f];
    
    self.publishCountLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15.0f];
    self.subscribersCountLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15.0f];
    self.subsCountLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15.0f];
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 45.0f;
    
    self.firstChildImageView.layer.masksToBounds = YES;
    self.secondChildImageView.layer.masksToBounds = YES;
    self.thirdChildImageView.layer.masksToBounds = YES;
    self.fourthChildImageView.layer.masksToBounds = YES;
    
    self.firstChildImageView.layer.cornerRadius = 25.0f;
    self.secondChildImageView.layer.cornerRadius = 25.0f;
    self.thirdChildImageView.layer.cornerRadius = 25.0f;
    self.fourthChildImageView.layer.cornerRadius = 25.0f;
    self.firstChildLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0f];
    self.secondChildLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0f];
    self.thirdChildLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0f];
    self.fourthChildLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0f];
}

@end
