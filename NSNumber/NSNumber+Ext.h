//
//  NSNumber+Ext.h
//  TT
//
//  Created by Aqib Mumtaz on 01/10/2013.
//  Copyright (c) 2013 Aqib Mumtaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Ext)

+ (NSNumber *)numberWithFloatUptoOneDigits:(float)floatValue;
+ (NSNumber *)numberWithFloatUptoTwoDigits:(float)floatValue;
+ (NSNumber *)increment:(NSNumber *)number by:(float)value;

@end
