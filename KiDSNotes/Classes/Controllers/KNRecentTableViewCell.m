//
//  KNRecentTableViewCell.m
//  KiDSNotes
//
//  Created by deus4 on 19/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "KNRecentTableViewCell.h"
#import <Parse/Parse.h>
#import "PAPUtility.h"


@interface KNRecentTableViewCell ()

@property (strong, nonatomic) IBOutlet PFImageView *imageUser;
@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UILabel *labelTimestamp;
@property (strong, nonatomic) IBOutlet UILabel *labelLastMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelCounter;

@end

@implementation KNRecentTableViewCell
@synthesize imageUser;
@synthesize labelUserName;
@synthesize labelTimestamp;
@synthesize labelLastMessage;
@synthesize recent;
@synthesize labelCounter;


- (void)awakeFromNib {

    self.imageUserPicture.layer.cornerRadius = 31;
    self.imageUserPicture.layer.masksToBounds = YES;
    [self layoutSubviews];

}
-(void)setRecent:(PFObject *)aRecent {
    recent = aRecent;

    
    PFUser *lastUser = recent[@"lastUser"];
    

    NSString *firstName = lastUser[@"firstName"];
    NSString *lastName = lastUser[@"lastName"];
    NSString *qandaString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    labelLastMessage.text = recent[@"lastMessage"];
    labelUserName.text = qandaString;
    
    int counter = [recent[@"counter"] intValue];
    labelCounter.text = (counter == 0) ? @"" : [NSString stringWithFormat:@"%d новых сообщения", counter];
    }



@end
