//
//  KNLoginViewController.m
//  KiDSNotes
//
//  Created by deus4 on 29/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "KNLoginViewController.h"
#import "ProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"
#import "push.h"
#import "common.h"

@interface KNLoginViewController ()
{
    BOOL _presentedLoginViewController;
    int _facebookResponseCount;
    int _expectedFacebookResponseCount;
    NSMutableData *_profilePicDataprog;
}
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registrationButton;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginView;
//new
@end

@implementation KNLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailTextField.font = [UIFont fontWithName:@"Lato-Light" size:15];
    
    self.passwordTextField.font = [UIFont fontWithName:@"Lato-Light" size:15];
    self.registrationButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.layer.masksToBounds = YES;
    
    //Position of the Facebook button
    CGFloat yPosition = 360.0f;
    if ([UIScreen mainScreen].bounds.size.height > 480.0f) {
        yPosition = 450.0f;
    }
    self.facebookLoginView.readPermissions = @[@"public_profile", @"user_friends", @"email", @"user_photos"];
    self.facebookLoginView.tooltipBehavior = FBSDKLoginButtonTooltipBehaviorDisable;
    // Do any additional setup after loading the view.
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    NSLog(@"editing started");
    UITextInputAssistantItem* item = [textField inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidAppear:(BOOL)animated    {
    [super viewDidAppear:animated];
    /*
    if ([PFUser currentUser]) {
        [self.navigationController performSegueWithIdentifier:@"loginActionSegue" sender:nil];
        
    }
     */
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error && error.code == kPFErrorObjectNotFound) {
            NSLog(@"User does not exist.");
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            return;
        }
        
        if (![FBSDKAccessToken currentAccessToken]) {
            NSLog(@"FB Session does not exist, logout");
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            return;
        }
        
        if (![FBSDKAccessToken currentAccessToken].userID) {
            NSLog(@"userID on FB Session does not exist, logout");
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            return;
        }
        
        PFUser *currentParseUser = [PFUser currentUser];
        if (!currentParseUser) {
            NSLog(@"Current Parse user does not exist, logout");
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            return;
        }
        
        NSString *facebookId = [currentParseUser objectForKey:kPAPUserFacebookIDKey];
        if (!facebookId || ![facebookId length]) {
            // set the parse user's FBID
            [currentParseUser setObject:[FBSDKAccessToken currentAccessToken].userID forKey:kPAPUserFacebookIDKey];
        }
        
        if (![PAPUtility userHasValidFacebookData:currentParseUser]) {
            NSLog(@"User does not have valid facebook ID. PFUser's FBID: %@, FBSessions FBID: %@. logout", [currentParseUser objectForKey:kPAPUserFacebookIDKey], [FBSDKAccessToken currentAccessToken].userID);
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            return;
        }
        
        // Finished checking for invalid stuff
        // Refresh FB Session (When we link up the FB access token with the parse user, information other than the access token string is dropped
        // By going through a refresh, we populate useful parameters on FBAccessTokenData such as permissions.
        [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                NSLog(@"Failed refresh of FB Session, logging out: %@", error);
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
                return;
            }
            // refreshed
            NSLog(@"refreshed permissions: %@", [FBSDKAccessToken currentAccessToken]);
            
            
            _expectedFacebookResponseCount = 0;
            FBSDKAccessToken *currentAccessToken = [FBSDKAccessToken currentAccessToken];
            if ([currentAccessToken hasGranted:@"public_profile"]) {
                // Logged in with FB
                // Create batch request for all the stuff
                FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
                _expectedFacebookResponseCount++;
                [connection addRequest:[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"name" }] completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if (error) {
                        // Failed to fetch me data.. logout to be safe
                        NSLog(@"couldn't fetch facebook /me data: %@, logout", error);
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
                        return;
                    }
                    
                    NSString *facebookName = result[@"name"];
                    if (facebookName && [facebookName length] != 0) {
                        [currentParseUser setObject:facebookName forKey:kPAPUserDisplayNameKey];
                    }
                    
                    [self processedFacebookResponse];
                }];
                
                // profile pic request
                _expectedFacebookResponseCount++;
                [connection addRequest:[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.width(500).height(500)"}] completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // result is a dictionary with the user's Facebook data
                        NSDictionary *userData = (NSDictionary *)result;
                        
                        NSURL *profilePictureURL = [NSURL URLWithString: userData[@"picture"][@"data"][@"url"]];
                        
                        // Now add the data to the UI elements
                        NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
                        [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
                    } else {
                        NSLog(@"Error getting profile pic url, setting as default avatar: %@", error);
                        NSData *profilePictureData = UIImagePNGRepresentation([UIImage imageNamed:@"AvatarPlaceholder.png"]);
                        [PAPUtility processFacebookProfilePictureData:profilePictureData];
                    }
                    [self processedFacebookResponse];
                }];
                if ([currentAccessToken hasGranted:@"user_friends"]) {
                    // Fetch FB Friends + me
                    _expectedFacebookResponseCount++;
                    [connection addRequest:[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends" parameters:@{ @"fields": @"id,name,first_name,last_name" }] completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        NSLog(@"processing Facebook friends");
                        if (error) {
                            // just clear the FB friend cache
                            [[PAPCache sharedCache] clear];
                        } else {
                            NSArray *data = [result objectForKey:@"data"];
                            NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
                            for (NSDictionary *friendData in data) {
                                if (friendData[@"id"]) {
                                    [facebookIds addObject:friendData[@"id"]];
                                }
                            }
                            // cache friend data
                            [[PAPCache sharedCache] setFacebookFriends:facebookIds];
                            
                            if ([currentParseUser objectForKey:kPAPUserFacebookFriendsKey]) {
                                [currentParseUser removeObjectForKey:kPAPUserFacebookFriendsKey];
                            }
                            if ([currentParseUser objectForKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey]) {
                          //      [(AppDelegate *)[[UIApplication sharedApplication] delegate] autoFollowUsers];
                            }
                        }
                        [self processedFacebookResponse];
                    }];
                }
                [connection start];
            } else {
                NSData *profilePictureData = UIImagePNGRepresentation([UIImage imageNamed:@"AvatarPlaceholder.png"]);
                [PAPUtility processFacebookProfilePictureData:profilePictureData];
                
                [[PAPCache sharedCache] clear];
                [currentParseUser setObject:@"Someone" forKey:kPAPUserDisplayNameKey];
                _expectedFacebookResponseCount++;
                [self processedFacebookResponse];
            }
            
            
        }];
    }];

}
#pragma mark - FBSDKLoginButtonDelegate

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error {
    if (!error) {
        [self handleFacebookSession];
    } else {
        [self handleLogInError:error];
    }
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}
- (void)handleFacebookSession {
    if ([PFUser currentUser]) {
        [self.navigationController performSegueWithIdentifier:@"loginActionSegue" sender:nil];
        return;
    }
    
    if (![FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Login failure. FB Access Token or user ID does not exist");
        return;
    }
    
    [ProgressHUD show:@"Uno momento!" Interaction:NO];
    
    [PFFacebookUtils logInInBackgroundWithAccessToken:[FBSDKAccessToken currentAccessToken] block:^(PFUser *user, NSError *error) {
        if (!error) {
            [ProgressHUD dismiss];
              [self.navigationController performSegueWithIdentifier:@"loginActionSegue" sender:nil];
        } else {
            //[self cancelLogIn:error];
        }
    }];
}
- (void)handleLogInError:(NSError *)error {
    if (error) {
        NSLog(@"Error: %@", [[error userInfo] objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"]);
        NSString *title = NSLocalizedString(@"Login Error", @"Login error title in PAPLogInViewController");
        NSString *message = NSLocalizedString(@"Something went wrong. Please try again.", @"Login error message in PAPLogInViewController");
        
        if ([[[error userInfo] objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"] isEqualToString:@"com.facebook.sdk:UserLoginCancelled"]) {
            return;
        }
        
        if (error.code == kPFErrorFacebookInvalidSession) {
            NSLog(@"Invalid session, logging out.");
            [FBSDKAccessToken setCurrentAccessToken:nil];
            return;
        }
        
        if (error.code == kPFErrorConnectionFailed) {
            NSString *ok = NSLocalizedString(@"OK", @"OK");
            NSString *title = NSLocalizedString(@"Offline Error", @"Offline Error");
            NSString *message = NSLocalizedString(@"Something went wrong. Please try again.", @"Offline message");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:ok, nil];
            [alert show];
            
            return;
        }
        
        NSString *ok = NSLocalizedString(@"OK", @"OK");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:ok, nil];
        [alertView show];
    }
}
- (IBAction)loginTouchButton:(UIButton *)sender {
    [ProgressHUD show:@"Uno momento!" Interaction:NO];
    
    if (![self validateEmail:self.emailTextField.text]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Не правильный эмайл"
                                                                       message:@"Пожалуйста проверьте данные."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        [ProgressHUD dismiss];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.text
                                 password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error)
     {
         if (nil == error) {
              [ProgressHUD showSuccess:@"Добро пожаловать" Interaction:YES];
             [self.navigationController performSegueWithIdentifier:@"loginActionSegue"
                                                            sender:nil];
         } else {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Не правильный эмайл/пароль"
                                                                            message:@"Пожалуйста проверьте данные."
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {}];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
             [ProgressHUD showError:nil];
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
#pragma mark - ()
- (void)processedFacebookResponse {
    // Once we handled all necessary facebook batch responses, save everything necessary and continue
    [ProgressHUD show:@"Один момент!" Interaction:false];

    @synchronized (self) {
        _facebookResponseCount++;
        if (_facebookResponseCount != _expectedFacebookResponseCount) {
            return;
        }
    }
    _facebookResponseCount = 0;
    NSLog(@"done processing all Facebook requests");
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"Failed save in background of user, %@", error);
        } else {
            NSLog(@"saved current parse user");
            [ProgressHUD dismiss];
            [self.navigationController performSegueWithIdentifier:@"loginActionSegue" sender:nil];
            ParsePushUserAssign();
            PostNotification(@"NCUserLoggedIn");
        }
    }];
}


@end
