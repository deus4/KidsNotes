//
//  CPhotoCommentViewController.h
//  KiDSNotes
//
//  Created by deus4 on 01/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPhotoCommentViewController : UIViewController

@property (strong, nonatomic) UIImage *imageToDisplay;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (id)initWithImage:(UIImage *)aImage;

@end
