//
//  IKProfileSettingsViewController.m
//  KiDSNotes
//
//  Created by deus4 on 27/06/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKProfileSettingsViewController.h"
#import "Parse.h"
#import "UIImage+ResizeAdditions.h"
#import "ProgressHUD.h"
#import "TTTTimeintervalFormatter.h"

@interface IKProfileSettingsViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UIView *profilePictureView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *childrenViewCollection;
@property (strong, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *townTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet PFImageView *firstChildImageView;
@property (strong, nonatomic) IBOutlet PFImageView *secondChildImageView;
@property (strong, nonatomic) IBOutlet PFImageView *thirdChildImageView;
@property (strong, nonatomic) IBOutlet PFImageView *forthChildImageView;

@property (strong, nonatomic) PFFile *avatarFile;
@property (strong, nonatomic) PFFile *thumbnailFile;
@property (strong, nonatomic) PFFile *childImageFile;
@property (strong, nonatomic) PFFile *childSecondImageFile;
@property (strong, nonatomic) PFFile *childThirdImageFile;
@property (strong, nonatomic) PFFile *childFourthImageFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (strong, nonatomic) IBOutletCollection(PFImageView) NSArray *childrenImageViewCollection;

@property (strong, nonatomic) IBOutlet UITextField *firstChildTextField;
@property (strong, nonatomic) IBOutlet UITextField *secondChildTextField;
@property (strong, nonatomic) IBOutlet UITextField *thirdChildTextField;
@property (strong, nonatomic) IBOutlet UITextField *forthChildTextField;
@property (strong, nonatomic) NSMutableArray *childrenArray;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *childrenNameTextFieldCollection;

@property (strong, nonatomic) IBOutlet UITextField *firstChildBirthdayTextField;
@property (strong, nonatomic) IBOutlet UITextField *secondChildBirthdayTextField;
@property (strong, nonatomic) IBOutlet UITextField *thirdChildBirthdayTextField;
@property (strong, nonatomic) IBOutlet UITextField *forthChildBirthdayTextField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *childrenBirthdayCollection;

@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;

@end

@implementation IKProfileSettingsViewController
@synthesize timeIntervalFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    self.childrenArray = [NSMutableArray array];
    self.userProfileImageView.layer.cornerRadius = 45.0f;
    self.profilePictureView.layer.cornerRadius = 45.0f;
    self.userProfileImageView.layer.masksToBounds = true;
    for (UIView *view in self.childrenViewCollection) {
        view.layer.cornerRadius = 20.0f;
    }
    for (PFImageView *imageView in self.childrenImageViewCollection) {
        imageView.layer.cornerRadius = 20.0f;
        imageView.layer.masksToBounds = true;
    }
    PFFile *userProfilePicture = [self.currentUser objectForKey:@"profilePictureMedium"];
    self.userProfileImageView.file = userProfilePicture;
    [self.userProfileImageView loadInBackground];
    self.displayNameTextField.text = [self.currentUser objectForKey:@"displayName"];
    self.townTextField.text = [self.currentUser objectForKey:@"city"];
    self.emailTextField.text = [self.currentUser objectForKey:@"email"];
    self.passwordTextField.text = [self.currentUser objectForKey:@"password"];
    self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc]init];
    [self loadChildrens];
}
- (void)loadChildrens {
    PFQuery *query = [PFQuery queryWithClassName:@"Children"];
    [query whereKey:@"Parent" equalTo:self.currentUser];
    [query orderByAscending:@"id"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            [self.childrenArray addObjectsFromArray:objects];
            for (PFObject *object in objects) {
                int childId = [[object valueForKey:@"id"] intValue];
                for (UITextField *textField in self.childrenNameTextFieldCollection) {
                    if ( childId == textField.tag) {
                        textField.text = [object objectForKey:@"name"];
                    }
                }
                
                NSTimeInterval timeInterval = [[object objectForKey:@"Birthday"] timeIntervalSinceNow];
                NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
                
                
                for (UITextField *textField in self.childrenBirthdayCollection) {
                    if ( childId == textField.tag) {
                        //textField.text = [NSString stringWithFormat:@"%.4f", timeInterval];
                        [textField setText:timestamp];
                    }
                }
                for (PFImageView *imageView in self.childrenImageViewCollection) {
                    if (childId == imageView.tag)   {
                        PFFile *imageFile = [object objectForKey:@"photo"];
                        [imageView setFile:imageFile];
                        [imageView loadInBackground];
                    }
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Button Actions
- (IBAction)addAvatarAction:(UIButton *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = true;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    if ([sender tag] == 0) {
        imagePickerController.view.tag = 0;
        // do something
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Фотография из камеры" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                 [self presentViewController:imagePickerController animated:YES completion:nil];
                                                             }];
        UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Фотография из библиотеки" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self presentViewController:imagePickerController animated:YES completion:nil];
                                                              }];
        [alert addAction:galleryAction];
        [alert addAction:cameraAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if ([sender tag] == 1) {
        imagePickerController.view.tag = 1;
        // do something
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Фотография из камеры" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                 [self presentViewController:imagePickerController animated:YES completion:nil];
                                                             }];
        UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Фотография из библиотеки" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self presentViewController:imagePickerController animated:YES completion:nil];
                                                              }];
        [alert addAction:galleryAction];
        [alert addAction:cameraAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if ([sender tag] == 2) {
        // do something
        imagePickerController.view.tag = 2;
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Фотография из камеры" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                 [self presentViewController:imagePickerController animated:YES completion:nil];
                                                             }];
        UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Фотография из библиотеки" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self presentViewController:imagePickerController animated:YES completion:nil];
                                                              }];
        [alert addAction:galleryAction];
        [alert addAction:cameraAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if ([sender tag] == 3) {
        imagePickerController.view.tag = 3;
        // do something
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Фотография из камеры" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                 [self presentViewController:imagePickerController animated:YES completion:nil];
                                                             }];
        UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Фотография из библиотеки" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self presentViewController:imagePickerController animated:YES completion:nil];
                                                              }];
        [alert addAction:galleryAction];
        [alert addAction:cameraAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if ([sender tag] == 4) {
        imagePickerController.view.tag = 4;
        // do something
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Фотография из камеры" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                 [self presentViewController:imagePickerController animated:YES completion:nil];
                                                             }];
        UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Фотография из библиотеки" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self presentViewController:imagePickerController animated:YES completion:nil];
                                                              }];
        [alert addAction:galleryAction];
        [alert addAction:cameraAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    if (picker.view.tag == 0) {
        self.userProfileImageView.image = image;
        [self shouldUploadImage:image];
    }
    //show the image view with the picked image
    if (picker.view.tag == 1) {
        self.firstChildImageView.image = image;
        [self shouldUploadChildImage:image];
    }
    if (picker.view.tag == 2) {
        self.secondChildImageView.image = image;
        [self shouldUploadSecondChildImage:image];
    }
    if (picker.view.tag == 3) {
        self.thirdChildImageView.image = image;
        [self shouldUploadThirdChildImage:image];
    }
    if (picker.view.tag == 4) {
        self.forthChildImageView.image = image;
        [self shouldUploadFourthChildImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldUploadChildImage:(UIImage *)anImage {
    UIImage *childImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(100.0f, 100.0f) interpolationQuality:kCGInterpolationHigh];
    NSData *thumbnailData = UIImageJPEGRepresentation(childImage, 1.0f);
    if (!thumbnailData) {
        return NO;
    }
    self.childImageFile = [PFFile fileWithData:thumbnailData];
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    [self.childImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
        if (error) {
            NSLog(@"Failed -%@",error.localizedDescription);
        }
    }];
    return YES;
}
- (BOOL)shouldUploadSecondChildImage:(UIImage *)anImage {
    UIImage *childImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(100.0f, 100.0f) interpolationQuality:kCGInterpolationHigh];
    NSData *thumbnailData = UIImageJPEGRepresentation(childImage, 1.0f);
    if (!thumbnailData) {
        return NO;
    }
    self.childSecondImageFile = [PFFile fileWithData:thumbnailData];
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    [self.childSecondImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
        if (error) {
            NSLog(@"Failed -%@",error.localizedDescription);
        }
    }];
    return YES;
}

- (BOOL)shouldUploadThirdChildImage:(UIImage *)anImage {
    UIImage *childImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(100.0f, 100.0f) interpolationQuality:kCGInterpolationHigh];
    NSData *thumbnailData = UIImageJPEGRepresentation(childImage, 1.0f);
    if (!thumbnailData) {
        return NO;
    }
    self.childThirdImageFile = [PFFile fileWithData:thumbnailData];
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    [self.childThirdImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
        if (error) {
            NSLog(@"Failed -%@",error.localizedDescription);
        }
    }];
    return YES;
}
- (BOOL)shouldUploadFourthChildImage:(UIImage *)anImage {
    UIImage *childImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(100.0f, 100.0f) interpolationQuality:kCGInterpolationHigh];
    NSData *thumbnailData = UIImageJPEGRepresentation(childImage, 1.0f);
    if (!thumbnailData) {
        return NO;
    }
    self.childFourthImageFile = [PFFile fileWithData:thumbnailData];
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    [self.childFourthImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
        if (error) {
            NSLog(@"Failed -%@",error.localizedDescription);
        }
    }];
    return YES;
}

- (BOOL)shouldUploadImage:(UIImage *)anImage    {
    UIImage *resizedAvatar = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(200.0f, 200.0f) interpolationQuality:kCGInterpolationHigh];
    
    UIImage *thumbnailImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(100.0f, 100.0f) interpolationQuality:kCGInterpolationHigh];
    
    NSData *avatarData = UIImageJPEGRepresentation(resizedAvatar, 1.0f);
    NSData *thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 1.0f);
    
    if (!avatarData || !thumbnailData) {
        return NO;
    }
    self.avatarFile = [PFFile fileWithData:avatarData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailData];
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    [self.avatarFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
        }   else    {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)saveUserProfileSettings:(UIButton *)sender {
    [ProgressHUD show:@"Идет обновления профиля..."Interaction:false];
    if (self.displayNameTextField.text && self.displayNameTextField.text.length > 0) {
        [self.currentUser setValue:self.displayNameTextField.text forKey:@"displayName"];
    }
    NSData *imageData = UIImageJPEGRepresentation(self.userProfileImageView.image, 1.0f);
    
    PFFile *userFile = [PFFile fileWithName:@"userPhoto.png" data:imageData];
    [self.currentUser setObject:userFile forKey:@"profilePictureMedium"];
    [self.currentUser setObject:userFile forKey:@"profilePictureSmall"];
    if (self.townTextField.text && self.townTextField.text.length > 0) {
        [self.currentUser setValue:self.townTextField.text forKey:@"city"];
    }
    if (self.emailTextField.text && self.emailTextField.text.length > 0) {
        [self.currentUser setValue:self.emailTextField.text forKey:@"email"];
    }
    if (self.firstChildTextField.text && self.firstChildTextField.text.length > 0) {
        if (0 < [self.childrenArray count]) {
            if ([self.childrenArray objectAtIndex:0] != nil) {
                PFObject *childObject = [self.childrenArray objectAtIndex:0];
                [childObject setValue:self.firstChildTextField.text forKey:@"name"];
                [childObject setObject:@0 forKey:@"id"];
                [childObject setObject:self.currentUser forKey:@"Parent"];
                if (self.firstChildImageView.image != nil) {
                    NSData *imageData = UIImageJPEGRepresentation(self.firstChildImageView.image, 1.0f);
                    PFFile *userFile = [PFFile fileWithName:@"childrenPicture.png" data:imageData];
                    [childObject setObject:userFile forKey:@"photo"];
                }
                
                [childObject saveInBackground];
            }

        } else {
            PFObject *childObject = [PFObject objectWithClassName:@"Children"];
            [childObject setValue:self.firstChildTextField.text forKey:@"name"];
            [childObject setObject:@0 forKey:@"id"];
            [childObject setObject:self.currentUser forKey:@"Parent"];
            if (self.firstChildImageView.image != nil) {
                NSData *imageData = UIImageJPEGRepresentation(self.firstChildImageView.image, 1.0f);
                PFFile *userFile = [PFFile fileWithName:@"childrenPicture.png" data:imageData];
                [childObject setObject:userFile forKey:@"photo"];
            }
            
            [childObject saveInBackground];
        }
        
    }
    if (self.secondChildTextField.text && self.secondChildTextField.text.length > 0) {
        if (1 < [self.childrenArray count]) {
            if ([self.childrenArray objectAtIndex:1] != nil) {
                PFObject *childObject = [self.childrenArray objectAtIndex:1];
                [childObject setValue:self.secondChildTextField.text forKey:@"name"];
                [childObject setObject:@1 forKey:@"id"];
                [childObject setObject:self.currentUser forKey:@"Parent"];
                if (self.secondChildImageView.image != nil) {
                    NSData *imageData = UIImageJPEGRepresentation(self.secondChildImageView.image, 1.0f);
                    PFFile *userFile = [PFFile fileWithName:@"childrenPicture.png" data:imageData];
                    [childObject setObject:userFile forKey:@"photo"];
                }
                
                [childObject saveInBackground];
            }

        } else {
            PFObject *childObject = [PFObject objectWithClassName:@"Children"];
            [childObject setValue:self.secondChildTextField.text forKey:@"name"];
            [childObject setObject:@1 forKey:@"id"];
            [childObject setObject:self.currentUser forKey:@"Parent"];
            if (self.secondChildImageView.image != nil) {
                NSData *imageData = UIImageJPEGRepresentation(self.secondChildImageView.image, 1.0f);
                PFFile *userFile = [PFFile fileWithName:@"childrenPicture.png" data:imageData];
                [childObject setObject:userFile forKey:@"photo"];
            }
            [childObject saveInBackground];
        }
        
    }
    if (self.thirdChildTextField.text && self.thirdChildTextField.text.length > 0) {
        if (2 < [self.childrenArray count]) {
            if ([self.childrenArray objectAtIndex:2] != nil) {
                PFObject *childObject = [self.childrenArray objectAtIndex:2];
                [childObject setValue:self.thirdChildTextField.text forKey:@"name"];
                [childObject setObject:@2 forKey:@"id"];
                [childObject setObject:self.currentUser forKey:@"Parent"];
                if (self.thirdChildImageView.image != nil) {
                    NSData *imageData = UIImageJPEGRepresentation(self.thirdChildImageView.image, 1.0f);
                    PFFile *userFile = [PFFile fileWithName:@"childrenPicture.png" data:imageData];
                    [childObject setObject:userFile forKey:@"photo"];
                }
                
                [childObject saveInBackground];
            }

        } else {
            PFObject *childObject = [PFObject objectWithClassName:@"Children"];
            [childObject setValue:self.thirdChildTextField.text forKey:@"name"];
            [childObject setObject:@2 forKey:@"id"];
            [childObject setObject:self.currentUser forKey:@"Parent"];
            if (self.thirdChildImageView.image != nil) {
                NSData *imageData = UIImageJPEGRepresentation(self.thirdChildImageView.image, 1.0f);
                PFFile *userFile = [PFFile fileWithName:@"childrenPicture.png" data:imageData];
                [childObject setObject:userFile forKey:@"photo"];
            }
            [childObject saveInBackground];
        }
    }
    if (self.forthChildTextField.text && self.forthChildTextField.text.length > 0) {
        if (3 < [self.childrenArray count]) {
            if ([self.childrenArray objectAtIndex:3] != nil) {
                PFObject *childObject = [self.childrenArray objectAtIndex:3];
                [childObject setValue:self.forthChildTextField.text forKey:@"name"];
                [childObject setObject:@3 forKey:@"id"];
                [childObject setObject:self.currentUser forKey:@"Parent"];
                if (self.forthChildImageView.image != nil) {
                    NSData *imageData = UIImageJPEGRepresentation(self.forthChildImageView.image, 1.0f);
                    PFFile *userFile = [PFFile fileWithName:@"childrenPicture.png" data:imageData];
                    [childObject setObject:userFile forKey:@"photo"];
                }
                
                [childObject saveInBackground];
            }

        } else {
            PFObject *childObject = [PFObject objectWithClassName:@"Children"];
            [childObject setValue:self.forthChildTextField.text forKey:@"name"];
            [childObject setObject:@3 forKey:@"id"];
            [childObject setObject:self.currentUser forKey:@"Parent"];
            if (self.forthChildImageView.image != nil)  {
                NSData *imageData = UIImageJPEGRepresentation(self.forthChildImageView.image, 1.0f);
                PFFile *userFile = [PFFile fileWithName:@"childrenPicture.png" data:imageData];
                [childObject setObject:userFile forKey:@"photo"];
            }
            [childObject saveInBackground];
        }
    }
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [ProgressHUD showSuccess:nil];
            [ProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ProgressHUD showError:nil];
            [ProgressHUD dismiss];
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
}

@end
