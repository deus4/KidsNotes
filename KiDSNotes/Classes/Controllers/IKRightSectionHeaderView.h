//
//  IKRightSectionHeaderView.h
//  KiDSNotes
//
//  Created by deus4 on 11/07/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
@protocol SectionHeaderViewDelegate;

@interface IKRightSectionHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet PFImageView *childrenImageView;
@property (strong, nonatomic) IBOutlet UILabel *childrenNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *disclosureButton;
@property (nonatomic, weak) IBOutlet id <SectionHeaderViewDelegate> delegate;
@property (nonatomic) NSInteger section;

- (void)toggleOpenWithUserAction:(BOOL)userAction;
@end
@protocol SectionHeaderViewDelegate <NSObject>
@optional
- (void)sectionHeaderView:(IKRightSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(IKRightSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section;
@end
