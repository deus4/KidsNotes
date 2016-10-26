//
//  KNPhotoCommentViewController.m
//  KiDSNotes
//
//  Created by deus4 on 10/12/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "KNPhotoCommentViewController.h"
#import "KNPhotoCommentsViewController.h"
#import "PAPCache.h"
#import "PAPConstants.h"


@interface KNPhotoCommentViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewToDisplay;
@property (strong, nonatomic) KNPhotoCommentsViewController *photoDetailsView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@end

@implementation KNPhotoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // KNPhotoCommentsViewController *myView
    self.photoDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoComments"];
    self.photoDetailsView.photo = self.photo;
    self.photoDetailsView.view.frame = self.viewToDisplay.bounds;
    [self.viewToDisplay addSubview:self.photoDetailsView.view];
    [self addChildViewController:self.photoDetailsView];

    
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(0.0, 40.0, 18.0, 12.0);
    [aButton setBackgroundImage:[UIImage imageNamed:@"backArrowComments"] forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(flipView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *anUIBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [anUIBarButtonItem setTintColor:[UIColor grayColor]];
    // self.navigationItem.rightBarButtonItem = anUIBarButtonItem;
    
    self.navigationItem.leftBarButtonItem = anUIBarButtonItem;

    // Do any additional setup after loading the view.
}

- (void)flipView
{
    [self.navigationController popViewControllerAnimated:YES];
    // do something or handle Search Button Action.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *trimmedComment = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0 && [self.photo objectForKey:kPAPPhotoUserKey]) {
        PFObject *comment = [PFObject objectWithClassName:kPAPActivityClassKey];
        [comment setObject:trimmedComment forKey:kPAPActivityContentKey]; // Set comment text
        [comment setObject:[self.photo objectForKey:kPAPPhotoUserKey] forKey:kPAPActivityToUserKey]; // Set toUser
        [comment setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey]; // Set fromUser
        [comment setObject:kPAPActivityTypeComment forKey:kPAPActivityTypeKey];
        [comment setObject:self.photo forKey:kPAPActivityPhotoKey];
        
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        [ACL setWriteAccess:YES forUser:[self.photo objectForKey:kPAPPhotoUserKey]];
        comment.ACL = ACL;
        
        [[PAPCache sharedCache] incrementCommentCountForPhoto:self.photo];
        
        // Show HUD view
     //   [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        
        // If more than 5 seconds pass since we post a comment, stop waiting for the server to respond
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(handleCommentTimeout:) userInfo:@{@"comment": comment} repeats:NO];
        
        [comment saveEventually:^(BOOL succeeded, NSError *error) {
            [timer invalidate];
            
            if (error && error.code == kPFErrorObjectNotFound) {
                [[PAPCache sharedCache] decrementCommentCountForPhoto:self.photo];

                [self.navigationController popViewControllerAnimated:YES];
            }
            
       //     [[NSNotificationCenter defaultCenter] postNotificationName:PAPPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:self.photo userInfo:@{@"comments": @(self.objects.count + 1)}];
            
         //   [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
          //  [self loadObjects];
            [self.photoDetailsView loadObjects];
        }];
    }
    
    [textField setText:@""];
    return [textField resignFirstResponder];
}
- (void)handleCommentTimeout:(NSTimer *)aTimer {
  //  [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
}
- (IBAction)sendComment:(id)sender {
    [self textFieldShouldReturn:self.commentTextField];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"alertview_embed"]) {

      //  AlertView * alertView = childViewController.view;
        // do something with the AlertView's subviews here...
    }
}

@end
