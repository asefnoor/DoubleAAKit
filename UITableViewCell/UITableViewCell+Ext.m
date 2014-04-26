//
//  UITableViewCell+Ext.m
//  TT
//
//  Created by Aqib Mumtaz on 09/10/2013.
//  Copyright (c) 2013 Aqib Mumtaz. All rights reserved.
//

#import "UITableViewCell+Ext.h"
#import "UIDevice+SystemVersion.h"

@implementation UITableViewCell (Ext)

- (UITableView *)uiTableView {
	if ([[UIDevice currentDevice] systemVersionIsGreaterThanOrEqualTo:@"7.0"]) {
		return (UITableView *)self.superview.superview;
	}
	else {
		return (UITableView *)self.superview;
	}
}

- (void)enableCell:(BOOL)enabled withText:(BOOL)dimText {
	if (enabled) {
		self.userInteractionEnabled = YES;

		if (dimText) {
			self.textLabel.alpha = 1.0f;
			self.alpha = 1.0f;
			self.detailTextLabel.hidden = NO;
		}
	}
	else {
		self.userInteractionEnabled = NO;

		if (dimText) {
			self.textLabel.alpha = 0.5f;
			self.alpha = 0.5f;
			self.detailTextLabel.hidden = YES;
		}
	}
}

- (void)enableCell:(BOOL)enabled withText:(BOOL)dimText withDisclosureIndicator:(BOOL)disclosureIndicator {
	[self enableCell:enabled withText:dimText withDetailText:dimText withDisclosureIndicator:disclosureIndicator];
}

- (void)enableCell:(BOOL)enabled withText:(BOOL)dimText withDetailText:(BOOL)dimDetailText withDisclosureIndicator:(BOOL)disclosureIndicator {
	if (enabled) {
		self.userInteractionEnabled = YES;

		if (dimText) {
			self.textLabel.alpha = 1.0f;
			self.alpha = 1.0f;
			if (dimDetailText) {
				self.detailTextLabel.alpha = 1.0f;
			}
			else {
				self.detailTextLabel.hidden = NO;
			}
		}

		self.accessoryType = disclosureIndicator ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	}
	else {
		self.userInteractionEnabled = NO;

		if (dimText) {
			self.textLabel.alpha = 0.5f;
			self.alpha = 0.5f;
			if (dimDetailText) {
				self.detailTextLabel.alpha = 0.5f;
			}
			else {
				self.detailTextLabel.hidden = YES;
			}
		}

		self.accessoryType = UITableViewCellAccessoryNone;
	}
}

- (void)disclosureIndicator:(BOOL)disclosureIndicator {
	if (disclosureIndicator) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else {
		self.accessoryType = UITableViewCellAccessoryNone;
	}
}

@end
