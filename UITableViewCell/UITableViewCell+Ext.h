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
- (void)enableCell:(BOOL)enabled withText:(BOOL)dimText;
- (void)enableCell:(BOOL)enabled withText:(BOOL)dimText withDisclosureIndicator:(BOOL)disclosureIndicator;
- (void)enableCell:(BOOL)enabled withText:(BOOL)dimText withDetailText:(BOOL)dimDetailText withDisclosureIndicator:(BOOL)disclosureIndicator;
- (void)disclosureIndicator:(BOOL)disclosureIndicator;

@end
