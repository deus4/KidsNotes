//
//  IKChlidrenInfo.m
//  KiDSNotes
//
//  Created by deus4 on 11/07/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKChlidrenInfo.h"

@implementation IKChlidrenInfo

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _rowHeights = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)countOfRowHeights {
    return [self.rowHeights count];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)idx {
    return self.rowHeights[idx];
}

- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx {
    [self.rowHeights insertObject:anObject atIndex:idx];
}

- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes {
    [self.rowHeights insertObjects:rowHeightArray atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx {
    [self.rowHeights removeObjectAtIndex:idx];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes {
    [self.rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject {
    self.rowHeights[idx] = anObject;
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray {
    [self.rowHeights replaceObjectsAtIndexes:indexes withObjects:rowHeightArray];
}

@end
