//
//  IKMenuViewController.h
//  KiDSNotes
//
//  Created by deus4 on 30/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IKMenuDataSource;

@interface IKMenuViewController : UIViewController <UITableViewDelegate>
{
    IBOutlet IKMenuDataSource *_dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

@end
