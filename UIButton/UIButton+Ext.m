//
//  UIButton+Ext.m
//  TT
//
//  Created by Aqib Mumtaz on 20/05/2014.
//  Copyright (c) 2014 Aqib Mumtaz. All rights reserved.
//

#import "UIButton+Ext.h"
#import "NSObject+Ext.h"

@implementation UIButton (Ext)

- (void)disableButtonForDelay:(NSTimeInterval)delay {
	// Disable Button for second
	self.enabled = NO;
	[self performBlock: ^{
	    self.enabled = YES;
	} afterDelay:delay];
}

@end
