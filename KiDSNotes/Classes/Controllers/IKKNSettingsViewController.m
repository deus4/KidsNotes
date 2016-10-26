//
//  IKKNSettingsViewController.m
//  KiDSNotes
//
//  Created by deus4 on 27/04/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKKNSettingsViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "IKSettingsTableViewHeaderView.h"
#import "IKSettingsMenuTableViewCell.h"

static NSString *SectionHeaderViewIdentifier = @"IKSettingsSectionHeaderView";
@interface IKKNSettingsViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *settings;
    NSArray *settingsSectionTitles;
}
@property (strong, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IKKNSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *user = [PFUser currentUser];
    PFFile *userProfilePictureFile = [user objectForKey:@"profilePictureMedium"];
    self.userProfileImageView.layer.masksToBounds = true;
    self.userProfileImageView.layer.cornerRadius = 15.0f;
    [self.userProfileImageView setFile:userProfilePictureFile];
    [self.userProfileImageView loadInBackground];
    
    settings = @{@"НАЙТИ ДРУЗЕЙ" : @[@"Найти друзей в Facebook", @"Найти друзей Вконтатке"],
                 @"ПРОФИЛЬ" : @[@"Редактировать профиль", @"Изменить пароль", @"Уведомления"],
                 @"ПОДДЕРЖКА" : @[@"Сообщить о проблеме"]};
    settingsSectionTitles = [[settings allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        UINib *sectionHeaderNib = [UINib nibWithNibName:@"IKSettingsTableViewHeaderView" bundle:nil];
       [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [settingsSectionTitles count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [settingsSectionTitles objectAtIndex:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    IKSettingsTableViewHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    NSString *sectionTitle = [settingsSectionTitles objectAtIndex:section];
    sectionHeaderView.settingTitleLabel.text = sectionTitle;
    return sectionHeaderView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [settingsSectionTitles objectAtIndex:section];
    NSArray *sectionAnimals = [settings objectForKey:sectionTitle];
    return [sectionAnimals count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IKSettingsMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *sectionTitle = [settingsSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionAnimals = [settings objectForKey:sectionTitle];
    NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
    cell.settingsLabel.text = animal;
    cell.settingsImageView.hidden = true;
    cell.settingsSwitch.hidden = true;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.settingsImageView.image = [UIImage imageNamed:@"fbIconSettings"];
        cell.settingsImageView.hidden = false;    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.bottomLine.hidden = true;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.settingsImageView.image = [UIImage imageNamed:@"vkIconSettings"];
        cell.settingsImageView.hidden = false;
        cell.bottomLine.hidden = true;
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        cell.settingsSwitch.hidden = false;
        cell.settingsButton.hidden = true;
        cell.bottomLine.hidden = true;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tap at row=)");
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"changeProfile" sender:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clearAction:(UIButton *)sender {
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KNNote" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [appDelegate.managedObjectContext deleteObject:managedObject];
        NSLog(@"object deleted");
    }
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Error deleting  - error:");
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
