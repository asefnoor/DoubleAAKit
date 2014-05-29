//
//  TableSection.m
//  ContactPicker
//
//  Created by Asif Noor on 19/05/2014.
//  Copyright (c) 2014 Tristan Himmelman. All rights reserved.
//

#import "CPTableSection.h"

@implementation CPTableSection

- (id)init {
	if (self = [super init]) {
		_contacts = [[NSMutableArray alloc] init];
	}
	return self;
}

@end
