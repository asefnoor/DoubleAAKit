//
//  NSObject+Ext.m
//  TT
//
//  Created by Aqib Mumtaz on 20/05/2014.
//  Copyright (c) 2014 Aqib Mumtaz. All rights reserved.
//

#import "NSObject+Ext.h"

@implementation NSObject (Ext)

- (void)performBlock:(void (^)())block {
	block();
}

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay {
	void (^block_)() = [block copy]; // autorelease this if you're not using ARC
	[self performSelector:@selector(performBlock:) withObject:block_ afterDelay:delay];
}

@end
