//
//  KNRecentTableViewCell.h
//  KiDSNotes
//
//  Created by deus4 on 19/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface KNRecentTableViewCell : PFTableViewCell

// The recent message displayed in the view
@property (nonatomic, strong) PFObject *recent;
@property (strong, nonatomic) IBOutlet PFImageView *imageUserPicture;



@end
