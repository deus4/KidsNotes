//
//  IKKNPhotoDetailsViewController.h
//  KiDSNotes
//
//  Created by deus4 on 10/05/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface IKKNPhotoDetailsViewController : PFQueryTableViewController<UITextFieldDelegate>
@property (nonnull, strong) PFObject *photo;

@end
