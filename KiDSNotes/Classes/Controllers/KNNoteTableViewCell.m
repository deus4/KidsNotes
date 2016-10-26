//
//  KNNoteTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 25/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "KNNoteTableViewCell.h"
#import "KNNote+CoreDataProperties.h"

@interface KNNoteTableViewCell ()


@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation KNNoteTableViewCell


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
}


- (void)configureWithNote:(KNNote *)note   {
    self.nameLabel.text = note.name;
    
}



+(void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSCurrentLocaleDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        sDateFormatter = nil;
        sNumberFormatter = nil;
    }];
}

// A date formatter for the creation date.
- (NSDateFormatter *)dateFormatter
{
    return [[self class] dateFormatter];
}


static NSDateFormatter *sDateFormatter = nil;

+ (NSDateFormatter *)dateFormatter
{
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
        [sDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [sDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    return sDateFormatter;
}
static NSNumberFormatter *sNumberFormatter = nil;

+ (NSNumberFormatter *)numberFormatter
{
    if (sNumberFormatter == nil) {
        sNumberFormatter = [[NSNumberFormatter alloc] init];
        [sNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [sNumberFormatter setMaximumFractionDigits:3];
    }
    return sNumberFormatter;
}
/*
 When the table view becomes editable, the cell should:
 * Hide the location label (so that the Delete button does not overlap it)
 * Enable the name field (to make it editable)
 * Display the tags button
 * Set a placeholder for the tags field (so the user knows to tap to edit tags)
 * Move the visible views out of the way of the edit icon.
 The inverse applies when the table view has finished editing.
 */

- (void)willTransitionToState:(UITableViewCellStateMask)state   {
    [super willTransitionToState:state];
    
    if (state & UITableViewCellStateEditingMask) {
        self.nameLabel.enabled = YES;
        
    }
}


- (void)didTransitionToState:(UITableViewCellStateMask)state    {
    [super didTransitionToState:state];
    
    if (!(state & UITableViewCellStateEditingMask)) {
        self.nameLabel.enabled = NO;
    }
}

/*
 Auto Layout workaround:
 
 Constraints made in the storyboard to the superview of views in the content view are made instead to the table view cell itself. This means that when the cell enters the editing state the content is not properly moved out of the way of the editing icons (the content view is shrunk to move content out of the way). A workaround is to remove the inappropriate constraints and recreate them substituting the content view for self.
 */
- (void)awakeFromNib
{
    NSArray *constraints = [self.constraints copy];
    
    for (NSLayoutConstraint *constraint in constraints) {
        
        id firstItem = constraint.firstItem;
        if (firstItem == self) {
            firstItem = self.contentView;
        }
        id secondItem = constraint.secondItem;
        if (secondItem == self) {
            secondItem = self.contentView;
        }
        
        NSLayoutConstraint *fixedConstraint = [NSLayoutConstraint constraintWithItem:firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:secondItem attribute:constraint.secondAttribute multiplier:constraint.multiplier constant:constraint.constant];
        
        [self removeConstraint:constraint];
        [self.contentView addConstraint:fixedConstraint];
    }
}

@end
