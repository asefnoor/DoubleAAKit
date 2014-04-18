//
//  UITableViewCell+Ext.h
//  TT
//
//  Created by Aqib Mumtaz on 09/10/2013.
//  Copyright (c) 2013 Aqib Mumtaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Ext)

- (UITableView *)uiTableView;
- (void)enableCell:(BOOL)enabled withText:(BOOL)text;
- (void)enableCell:(BOOL)enabled withText:(BOOL)text withDisclosureIndicator:(BOOL)disclosureIndicator;
- (void)disclosureIndicator:(BOOL)disclosureIndicator;

@end
