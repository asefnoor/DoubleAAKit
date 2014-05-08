//
//  NSManagedObject+Ext.m
//  TT
//
//  Created by Aqib Mumtaz on 17/09/2013.
//  Copyright (c) 2013 Aqib Mumtaz. All rights reserved.
//

#import "NSManagedObject+Ext.h"
#import "NSManagedObjectContext+Ext.h"
#import "AppDelegate.h"

@implementation NSManagedObject (Ext)

- (void)save {
	NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

	[managedObjectContext saveContext];
}

- (NSURL *)objectIDURI {
	return [[self objectID] URIRepresentation];
}

- (NSString *)objectIDURIString {
	return [[[self objectID] URIRepresentation] absoluteString];
}

@end
