//
//  KNNote+CoreDataProperties.h
//  KiDSNotes
//
//  Created by deus4 on 25/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KNNote.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNNote (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
