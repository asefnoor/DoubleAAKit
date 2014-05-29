//
//  UIViewController+Ext.m
//  TT
//
//  Created by Aqib Mumtaz on 08/05/2014.
//  Copyright (c) 2014 Aqib Mumtaz. All rights reserved.
//

#import "UIViewController+Ext.h"

@implementation UIViewController (Ext)

- (BOOL)isVisible {
	return [self isViewLoaded] && self.view.window;
}

- (BOOL)isPresented {
	return self.presentingViewController != nil;
}

@end
