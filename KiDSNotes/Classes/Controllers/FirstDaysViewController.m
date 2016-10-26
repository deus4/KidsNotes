//
//  FirstDaysViewController.m
//  KiDSNotes
//
//  Created by deus4 on 23/11/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "FirstDaysViewController.h"
#import "FirstDaysTableViewCell.h"
#import "DataManager.h"
#import "Message.h"

static NSString * const CellIdentifier = @"Cell";

@interface FirstDaysViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FirstDaysViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *item = [[DATA messages]objectAtIndex:indexPath.row];
    
    static NSString *cellIdent = @"Cell";
    FirstDaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];

   // cell.postTextlabel.text = item.lastMessage;
    cell.profilePicture.clipsToBounds = YES;
    cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2;
    cell.profilePicture.image = [UIImage imageNamed:item.userPhoto];
    cell.headerLabel.text = @"Каждый веб-разработчик знает, что такое текст-«рыба».";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static FirstDaysTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}
- (void)configureBasicCell:(FirstDaysTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Message *item = [[DATA messages]objectAtIndex:indexPath.row];
    
    [self setTitleForCell:cell item:item];
    [self setSubtitleForCell:cell item:item];
}
- (void)setTitleForCell:(FirstDaysTableViewCell *)cell item:(Message *)item {
    cell.userNameLabel.text = item.userName;
}
- (void)setSubtitleForCell:(FirstDaysTableViewCell *)cell item:(Message *)item {
    NSString *subtitle = item.lastMessage;
    
    // Some subtitles can be really long, so only display the
    // first 200 characters
    if (subtitle.length > 200) {
        subtitle = [NSString stringWithFormat:@"%@...", [subtitle substringToIndex:200]];
    }
    [cell.postTextlabel setText:subtitle];
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
