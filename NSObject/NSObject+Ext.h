//
//  NSObject+Ext.h
//  TT
//
//  Created by Aqib Mumtaz on 20/05/2014.
//  Copyright (c) 2014 Aqib Mumtaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Ext)

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end
