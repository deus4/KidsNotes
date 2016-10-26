//
//  KNMessagesViewController.m
//  KiDSNotes
//
//  Created by deus4 on 19/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "KNMessagesViewController.h"
#import "UIView+Fonts.h"
#import "UIViewController+ECSlidingViewController.h"
#import "KNSelectSingleView.h"
#import "recent.h"
#import "ChatView.h"
#import "KNSelectSingleViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation KNMessagesViewController


- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self
                                                                                           action:@selector(null)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x9FD7B0)];
    
    UIImage *myImage = [UIImage imageNamed:@"barBearMenu"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc]initWithImage:myImage
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(touchMenuSandwich)];
    
    self.navigationItem.leftBarButtonItem=_btn;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont fontWithName:@"PFKidsPro-GradeFive" size:15]
                                                                    };
    self.title = @"СООБЩЕНИЯ";
}
/*
- (void)actionCompose   {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Сообщение другу", nil];
    [action showFromTabBar:[[self tabBarController] tabBar]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (buttonIndex == 0)
        {
            KNSelectSingleView * selectSingleView = (KNSelectSingleView *)[self.storyboard instantiateViewControllerWithIdentifier:@"KNSelectSingleView"];
          //  KNSelectSingleView *vc = [[KNSelectSingleView alloc] init];
            selectSingleView.delegate = self;
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:selectSingleView];
            [self presentViewController:navigationController animated:YES completion:nil];
//            SelectSingleView *selectSingleView = [[SelectSingleView alloc] init];
//            selectSingleView.delegate = self;
//            NavigationController *navController = [[NavigationController alloc] initWithRootViewController:selectSingleView];
//            [self presentViewController:navController animated:YES completion:nil];
        }
    }
}
 */
- (void)didSelectSingleUser:(PFUser *)user2
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user1 = [PFUser currentUser];
    NSString *groupId = StartPrivateChat(user1, user2);
    [self actionChat:groupId];
}
- (void)actionChat:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)touchMenuSandwich {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
@end
