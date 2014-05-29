//
//  ContactPickerViewController.h
//  ContactPicker
//
//  Created by Tristan Himmelman on 11/2/12.
//  Copyright (c) 2012 Tristan Himmelman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "THContactPickerView.h"
#import "THContactPickerTableViewCell.h"

@interface THContactPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, THContactPickerDelegate>

@property (nonatomic, strong) THContactPickerView *contactPickerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSString *rightNavigationItemTitle;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSArray *filteredSectionsWithContacts;
@property (nonatomic, strong) NSArray *tableSections;
@property (nonatomic, strong) void (^getSelectedContactsCallback)(NSArray *contacts);
- (void)setup:(NSMutableArray *)sectionList;
- (void)presentMeInViewController:(UIViewController *)parentVC;
- (void)dismissMe;
- (void)popMe;
@end
