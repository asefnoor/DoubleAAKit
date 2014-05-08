//
//  NSNumber+Ext.m
//  TT
//
//  Created by Aqib Mumtaz on 01/10/2013.
//  Copyright (c) 2013 Aqib Mumtaz. All rights reserved.
//

#import "NSNumber+Ext.h"

@implementation NSNumber (Ext)

+ (NSNumber *)numberWithFloatUptoOneDigits:(float)floatValue {
	NSString *stringValue = [NSString stringWithFormat:@"%.1f", floatValue];
	return @([stringValue floatValue]);
}

+ (NSNumber *)numberWithFloatUptoTwoDigits:(float)floatValue {
	NSString *stringValue = [NSString stringWithFormat:@"%.02f", floatValue];
	return @([stringValue floatValue]);
}

+ (NSNumber *)increment:(NSNumber *)number by:(float)value {
	float numberFloat = [number floatValue] + value;
	return [NSNumber numberWithFloatUptoOneDigits:numberFloat];
}

@end
