//
//  IKRegistrationViewController.m
//  KiDSNotes
//
//  Created by deus4 on 05/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKRegistrationViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "ProgressHUD.h"

#import "utilities.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface IKRegistrationViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *avatarView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstLastNameLabel;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *kidsAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UILabel *fotoNameKidLabel;
@property (strong, nonatomic) IBOutlet UIButton *createProfileButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet PFImageView *firstChildImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondChildImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdChildImageView;
@property (strong, nonatomic) IBOutlet UIImageView *forthChildImageView;
@property (strong, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UITextField *firstChildTextField;
@property (strong, nonatomic) IBOutlet UITextField *secondChildTextField;
@property (strong, nonatomic) IBOutlet UITextField *thirdChildTextField;
@property (strong, nonatomic) IBOutlet UITextField *forthChildTextField;

@property (strong, nonatomic) PFFile *avatarFile;
@property (strong, nonatomic) PFFile *thumbnailFile;
@property (strong, nonatomic) PFFile *childImageFile;
@property (strong, nonatomic) PFFile *childSecondImageFile;
@property (strong, nonatomic) PFFile *childThirdImageFile;
@property (strong, nonatomic) PFFile *childFourthImageFile;


@property (strong, nonatomic) NSMutableArray *childrenArray;

@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;

@end

@implementation IKRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:UIColorFromRGB(0x009FE8),
       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:20]}];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 45.0f;
    self.firstLastNameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0f];
    self.cityLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0f];
    self.passwordLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0f];
    self.emailLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10.0f];
    self.fotoNameKidLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12.0f];
    self.createProfileButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0f];
    for (UIImageView *kidView in self.kidsAvatarImageView) {
        kidView.layer.masksToBounds = YES;
        kidView.layer.cornerRadius = 20.0f;
    }
    
    self.childrenArray = [[NSMutableArray alloc]init];
    // self.firstLastNameLabel.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)navigationBarButtonBackTouch:(id)sender {
    //Show previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addAvatarButtonPressed:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    
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
        imagePickerController.view.tag = 2;
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
    if ([sender tag] == 3) {
        // do something
        imagePickerController.view.tag = 3;
        
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
    if ([sender tag] == 5) {
        imagePickerController.view.tag = 5;
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
    NSLog(@"%@",sender);
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    if (picker.view.tag == 1) {
        self.avatarImageView.image = image;
        [self shouldUploadImage:image];
    }
    //show the image view with the picked image
    if (picker.view.tag == 2) {
        self.firstChildImageView.image = image;
        [self shouldUploadChildImage:image];
    }
    if (picker.view.tag == 3) {
        self.secondChildImageView.image = image;
        [self shouldUploadSecondChildImage:image];
    }
    if (picker.view.tag == 4) {
        self.thirdChildImageView.image = image;
        [self shouldUploadThirdChildImage:image];
    }
    if (picker.view.tag == 5) {
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
- (IBAction)createProfile:(id)sender {
    if (![self validateEmail:self.emailTextField.text]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"EMAIL написан неправильно"
                                                                       message:@"Пожалуйста проверьте."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (!self.avatarFile || !self.thumbnailFile) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Не загрузилась фотография профиля"
                                                                       message:@"Пожалуйста попробуйте заново."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (!(self.displayNameTextField.text.length > 0)) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Имя обязательно для заполнения"
                                                                       message:@"Пожалуйста попробуйте заново."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (!(self.passwordTextField.text.length >0)) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Пароль обязателен для заполнения"
                                                                       message:@"Пожалуйста попробуйте заново."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    PFUser *user = [PFUser user];
    user.username = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    [user setObject:self.displayNameTextField.text forKey:@"displayName"];
    [user setObject:self.cityTextField.text forKey:@"city"];
    [user setObject:self.avatarFile forKey:@"profilePictureMedium"];
    [user setObject:self.thumbnailFile forKey:@"profilePictureSmall"];
    
    


    
    
    
    
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            ParsePushUserAssign();
            if (self.childImageFile) {
                PFObject *childObject = [PFObject objectWithClassName:@"Children"];
                [childObject setObject:self.firstChildTextField.text forKey:@"name"];
                [childObject setObject:self.childImageFile forKey:@"photo"];
                [childObject setObject:user forKey:@"Parent"];
                
                
                [childObject saveInBackground];

            }
            
            if (self.childSecondImageFile) {
                PFObject *childObject = [PFObject objectWithClassName:@"Children"];
                [childObject setObject:self.secondChildTextField.text forKey:@"name"];
                [childObject setObject:self.childSecondImageFile forKey:@"photo"];
                [childObject setObject:user forKey:@"Parent"];
                
                
                [childObject saveInBackground];
                
            }
            if (self.childThirdImageFile) {
                PFObject *childObject = [PFObject objectWithClassName:@"Children"];
                [childObject setObject:self.thirdChildTextField.text forKey:@"name"];
                [childObject setObject:self.childThirdImageFile forKey:@"photo"];
                [childObject setObject:user forKey:@"Parent"];
                [childObject saveInBackground];
            }
            if (self.childFourthImageFile) {
                PFObject *childObject = [PFObject objectWithClassName:@"Children"];
                [childObject setObject:self.forthChildTextField.text forKey:@"name"];
                [childObject setObject:self.childFourthImageFile forKey:@"photo"];
                [childObject setObject:user forKey:@"Parent"];
                [childObject saveInBackground];
            }
            
            [self.navigationController performSegueWithIdentifier:@"loginActionSegue" sender:nil];
        }   else    {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Пользователь с данным эмайлом уже создан."
                                                                           message:@"Пожалуйста попробуйте другую почту."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    
    
    
}
- (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
@end
