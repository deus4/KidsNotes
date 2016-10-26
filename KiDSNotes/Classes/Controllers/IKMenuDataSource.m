//
//  IKMenuDataSource.m
//  KiDSNotes
//
//  Created by deus4 on 01/02/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKMenuDataSource.h"
#import "IKMenuItem.h"
#import "IKMenuTableViewCell.h"


@interface IKMenuDataSource ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation IKMenuDataSource
- (NSArray *)items
{
    if (nil == _items) {
        _items = @[[[IKMenuItem alloc] initWithTitle:@"Профиль" icon:@"profile_icon" itemId:IK_MENU_ITEM_PROFILE],
                   [[IKMenuItem alloc] initWithTitle:@"Лента" icon:@"feed_icon" itemId:IK_MENU_ITEM_FEED],
                   [[IKMenuItem alloc] initWithTitle:@"Друзья" icon:@"friends_icon" itemId:IK_MENU_ITEM_FRIENDS],
                   [[IKMenuItem alloc] initWithTitle:@"Дети" icon:@"friends_icon" itemId:IK_MENU_ITEM_KIDS],
                   [[IKMenuItem alloc] initWithTitle:@"Сообщения" icon:@"messages_icon" itemId:IK_MENU_ITEM_MESSAGES],
                   [[IKMenuItem alloc] initWithTitle:@"Настройки" icon:@"settings_icon" itemId:IK_MENU_ITEM_SETTINGS]];
    }
    return _items;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IKMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    [self tableView:tableView configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView configureCell:(IKMenuTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IKMenuItem *item = self.items[indexPath.row];
    cell.menuTextLabel.text = item.title;
    cell.menuIconButton.image = item.icon;
    cell.itemId = item.itemId;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
