//
//  Contact.h
//  ContactPicker
//
//  Created by Asif Noor on 19/05/2014.
//  Copyright (c) 2014 Tristan Himmelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPContact : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) UIImage *image;

@end
