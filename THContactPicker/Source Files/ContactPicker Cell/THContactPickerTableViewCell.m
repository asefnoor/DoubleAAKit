//
//  THContactPickerTableViewCell.m
//  ContactPicker
//
//  Created by Mac on 3/27/14.
//  Copyright (c) 2014 Tristan Himmelman. All rights reserved.
//

#import "THContactPickerTableViewCell.h"

@implementation THContactPickerTableViewCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) refreshLayoutWithoutImage{
    CGRect rect = self.fullNameLabel.frame;
    [self setSeparatorInset:UIEdgeInsetsZero];
    
    rect.origin.x = 46;
    self.fullNameLabel.frame = rect;
    CGRect emailRect = self.emailLabel.frame;
    emailRect.origin.x = 46;
    self.emailLabel.frame = emailRect;
    
}

@end
