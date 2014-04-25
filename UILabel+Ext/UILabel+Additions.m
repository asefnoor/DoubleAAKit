//
//  UILabel+Additions.m
//  TTiPhone
//
//  Created by Asif Noor on 25/04/2014.
//  Copyright (c) 2014 Asif Noor. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (void)requiredLabel {
    
    NSString *labelText = [NSString stringWithFormat:@"%@ *",self.text];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSLog(@"length:%d",[text length]);
    [text addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange([text length]-1, 1)];
    [self setAttributedText: text];
}

@end
