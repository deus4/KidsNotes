//
//  MessagesViewController.m
//  KiDSNotes
//
//  Created by deus4 on 20/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "MessagesViewController.h"
#import "DataManager.h"
#import "Message.h"
#import "MessageTableViewCell.h"

@interface MessagesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KIDSNOTES";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DATA messages]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *item = [[DATA messages]objectAtIndex:indexPath.row];
    
    static NSString *cellIdent = @"Cell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent forIndexPath:indexPath];
    cell.userName.text = item.userName;
    cell.lastMessage.text = item.lastMessage;
    cell.profilePhoto.layer.cornerRadius = cell.profilePhoto.frame.size.width / 2;
    cell.profilePhoto.clipsToBounds = YES;
    cell.profilePhoto.image = [UIImage imageNamed:item.userPhoto];
    
    return cell;
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
