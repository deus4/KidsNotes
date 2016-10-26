//
//  CameraViewController.h
//  KiDSNotes
//
//  Created by deus4 on 01/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "ViewController.h"
#import "PreviewView.h"

@interface CameraViewController : UIViewController
@property (strong, nonatomic) IBOutlet PreviewView *frameForCapture;
@property (strong, nonatomic) UIImage *captureImage;

@end
