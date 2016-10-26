//
//  IKProfileImageView.m
//  KiDSNotes
//
//  Created by deus4 on 04/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKProfileImageView.h"

#import "ParseUI/ParseUI.h"

@interface IKProfileImageView ()
@property (nonatomic, strong) UIImageView *borderImageview;
@end

@implementation IKProfileImageView

@synthesize borderImageview;
@synthesize profileImageView;
@synthesize profileButton;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.profileImageView = [[PFImageView alloc] initWithFrame:self.frame];
        [self addSubview:self.profileImageView];
        
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.profileButton];
        
        [self addSubview:self.borderImageview];
    }
    return self;
}
- (void)layoutSubviews  {
    [super layoutSubviews];
    [self bringSubviewToFront:self.borderImageview];
    
    self.profileImageView.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.borderImageview.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.profileButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);}

- (void)setFile:(PFFile *)file  {
    if (!file) {
        return;
    }
    self.profileImageView.image = [UIImage imageNamed:@"avatarPlaceholder"];
    self.profileImageView.file = file;
    [self.profileImageView loadInBackground];
}

- (void)setImage:(UIImage *)image   {
    self.profileImageView.image = image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
