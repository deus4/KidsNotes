//
//  IKChlidrenInfo.h
//  KiDSNotes
//
//  Created by deus4 on 11/07/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class IKRightSectionHeaderView;

@interface IKChlidrenInfo : NSObject
@property (getter = isOpen) BOOL open;
@property PFObject *children;
@property IKRightSectionHeaderView *headerView;

@property (nonatomic) NSMutableArray *rowHeights;


- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;

@end
