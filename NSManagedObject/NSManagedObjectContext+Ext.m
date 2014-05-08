//
//  NSManagedObjectContext+Ext.m
//  TT
//
//  Created by Aqib Mumtaz on 10/10/2013.
//  Copyright (c) 2013 Aqib Mumtaz. All rights reserved.
//

#import "NSManagedObjectContext+Ext.h"
#import "Includes.h"

@implementation NSManagedObjectContext (Ext)

- (void)saveContext {
	NSError *error;

	//
	if (![self save:&error]) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}
}

- (NSManagedObject *)objectWithURI:(NSURL *)uri {
	NSManagedObjectID *objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:uri];

	if (!objectID) {
		return nil;
	}

	NSManagedObject *objectForID = [self objectWithID:objectID];
	if (![objectForID isFault]) {
		return objectForID;
	}

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[objectID entity]];

	// Equivalent to predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
	NSPredicate *predicate = [NSComparisonPredicate
	                          predicateWithLeftExpression:
	                          [NSExpression expressionForEvaluatedObject]
	                          rightExpression:
	                          [NSExpression expressionForConstantValue:objectForID]
	                          modifier:NSDirectPredicateModifier
	                          type:NSEqualToPredicateOperatorType
	                          options:0];
	[request setPredicate:predicate];

	NSArray *results = [self executeFetchRequest:request error:nil];
	if ([results count] > 0) {
		return [results objectAtIndex:0];
	}

	return nil;
}

- (BOOL)undoCoreData {
	BOOL undoSuccessfull = NO;

	if ([self.undoManager canUndo] && ![self.undoManager isUndoing]) {
		@try {
			//        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
			[self.undoManager undo];

			[self saveContext];

			undoSuccessfull = TRUE;
		}
		@catch (NSException *exception)
		{
			NSLog(@"Exception : %@", exception);

			[[[UIAlertView alloc] initWithTitle:@"Exception"
			                            message:[NSString stringWithFormat:@"%@", exception]
			                   cancelButtonItem:[RIButtonItem itemWithLabel:@"Ok" action: ^{
			    NSLog(@"Ok");
			}]
			                   otherButtonItems:nil, nil] show];

			undoSuccessfull = NO;
		}
		@finally
		{
		}
	}
	else {
		if ([self.undoManager isUndoing]) {
			NSLog(@"Undo in progress.");

			[[[UIAlertView alloc] initWithTitle:@"Can't Undo"
			                            message:@"Undo in progress."
			                   cancelButtonItem:[RIButtonItem itemWithLabel:@"Ok" action: ^{
			    NSLog(@"Ok");
			}]
			                   otherButtonItems:nil, nil] show];
		}
		else {
			NSLog(@"No more Undo.");

			[[[UIAlertView alloc] initWithTitle:@"Can't Undo"
			                            message:@"No more Undo."
			                   cancelButtonItem:[RIButtonItem itemWithLabel:@"Ok" action: ^{
			    NSLog(@"Ok");
			}]
			                   otherButtonItems:nil, nil] show];
		}
	}

	return undoSuccessfull;
}

- (BOOL)redoCoreData {
	BOOL redoSuccessfull = NO;

	if ([self.undoManager canRedo] && ![self.undoManager isRedoing]) {
		@try {
			//        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
			[self.undoManager redo];

			[self saveContext];

			redoSuccessfull = TRUE;
		}
		@catch (NSException *exception)
		{
			NSLog(@"Exception : %@", exception);

			[[[UIAlertView alloc] initWithTitle:@"Exception"
			                            message:[NSString stringWithFormat:@"%@", exception]
			                   cancelButtonItem:[RIButtonItem itemWithLabel:@"Ok" action: ^{
			    NSLog(@"Ok");
			}]
			                   otherButtonItems:nil, nil] show];

			redoSuccessfull = NO;
		}
		@finally
		{
		}
	}
	else {
		if ([self.undoManager isRedoing]) {
			NSLog(@"Redo in progress.");

			[[[UIAlertView alloc] initWithTitle:@"Can't Redo"
			                            message:@"Redo in progress."
			                   cancelButtonItem:[RIButtonItem itemWithLabel:@"Ok" action: ^{
			    NSLog(@"Ok");
			}]
			                   otherButtonItems:nil, nil] show];
		}
		else {
			NSLog(@"No more Redo.");

			[[[UIAlertView alloc] initWithTitle:@"Can't Redo"
			                            message:@"No more Redo."
			                   cancelButtonItem:[RIButtonItem itemWithLabel:@"Ok" action: ^{
			    NSLog(@"Ok");
			}]
			                   otherButtonItems:nil, nil] show];
		}
	}

	return redoSuccessfull;
}

- (void)enableUndo {
	if (![self.undoManager isUndoRegistrationEnabled]) {
		[self processPendingChanges];
		[self.undoManager enableUndoRegistration];
	}
	else {
		NSLog(@"Undo Registration is already enabled.");
	}
}

- (void)disableUndo {
	if ([self.undoManager isUndoRegistrationEnabled]) {
		[self processPendingChanges];

		[self.undoManager removeAllActions];

		[self.undoManager disableUndoRegistration];
	}
	else {
		NSLog(@"Undo Registration is already disabed.");
	}
}

@end
