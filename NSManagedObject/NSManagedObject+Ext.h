//
//  NSManagedObject+Ext.h
//  TT
//
//  Created by Aqib Mumtaz on 17/09/2013.
//  Copyright (c) 2013 Aqib Mumtaz. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Ext)

- (void)save;
- (NSURL *)objectIDURI;
- (NSString *)objectIDURIString;

@end
