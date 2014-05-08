//
//  NSManagedObjectContext+Ext.h
//  TT
//
//  Created by Aqib Mumtaz on 10/10/2013.
//  Copyright (c) 2013 Aqib Mumtaz. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Ext)

- (void)saveContext;

- (NSManagedObject *)objectWithURI:(NSURL *)uri;

- (BOOL)undoCoreData;
- (BOOL)redoCoreData;
- (void)enableUndo;
- (void)disableUndo;

@end
