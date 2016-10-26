//
//  KNCameraImagePickerViewController.m
//  KiDSNotes
//
//  Created by deus4 on 18/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNCameraImagePickerViewController.h"
#import "TWPhotoPickerController.h"
#import "CPhotoCommentViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface KNCameraImagePickerViewController ()
@property (strong, nonatomic) CPhotoCommentViewController *photoPostController;
@property (strong, nonatomic) UIImage *choosenImage;
@end

@implementation KNCameraImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TWPhotoPickerController *photoPicker = [[TWPhotoPickerController alloc] init];
    // Do any additional setup after loading the view.
    photoPicker.view.backgroundColor = UIColorFromRGB(0x202125);
    //photoPicker.v
    photoPicker.view.frame = self.view.bounds;
    [self.view addSubview:photoPicker.view];
    [self addChildViewController:photoPicker];
    self.photoPostController = [self.storyboard instantiateViewControllerWithIdentifier:@"postPhotoViewController"];
    [photoPicker didMoveToParentViewController:self];
    photoPicker.cropBlock = ^(UIImage *image) {
        //do something
        self.choosenImage = image;
        [self performSegueWithIdentifier:@"choosePhoto" sender:self];
    };
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"choosePhoto"])
    {
        CPhotoCommentViewController *vc = [segue destinationViewController];
        vc.imageToDisplay = self.choosenImage;
        // Get reference to the destination view controller
   //     CPhotoCommentViewController *vc = [segue destinationViewController];
      //  vc.imageToDisplay = self.captureImage;
        // Pass any objects to the view controller here, like...
        //   [vc setMyObjectHere:object];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
