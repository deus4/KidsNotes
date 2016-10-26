//
//  ChatView.h
//  KiDSNotes
//
//  Created by deus4 on 19/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface ChatView : JSQMessagesViewController

-(id)initWith:(NSString *)groupId_;
@property (nonatomic, strong) NSString *selectedUserName;
@end
