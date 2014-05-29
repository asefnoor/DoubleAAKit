//
//  ContactPickerViewController.m
//  ContactPicker
//
//  Created by Tristan Himmelman on 11/2/12.
//  Copyright (c) 2012 Tristan Himmelman. All rights reserved.
//

#import "THContactPickerViewController.h"
#import <AddressBook/AddressBook.h>
#import "CPTableSection.h"
#import "CPContact.h"

#define SelectedImage @"icon-checkbox-selected-green-25x25"
#define UnSelectedImage @"icon-checkbox-unselected-25x25"
UIBarButtonItem *barButton;
UIBarButtonItem *toggleContactSelectionBarItem;
struct ContactIndexPath
{
	NSUInteger sectionNumber;
	NSUInteger rowNumber;
};
@interface THContactPickerViewController () {
	NSMutableArray *searchResultSections;
	BOOL isDisplayContactImage;
	BOOL presented;
}

- (struct ContactIndexPath)indexPathOfContactInTable:(id)contact;
- (BOOL)isValidEmail:(NSString *)checkString;
@end

//#define kKeyboardHeight 216.0
#define kKeyboardHeight 0.0

@implementation THContactPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = @"Select Contacts (0)";
		self.headerTitle = @"Add Members (%lu)";
		_rightNavigationItemTitle = @"Done";
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	//	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(removeAllContacts:)];
	toggleContactSelectionBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:UnSelectedImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleAllContactsSelection:)];
	self.navigationItem.leftBarButtonItem = toggleContactSelectionBarItem;
    
	barButton = [[UIBarButtonItem alloc] initWithTitle:_rightNavigationItemTitle style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
	barButton.enabled = FALSE;
    
	self.navigationItem.rightBarButtonItem = barButton;
    
	// Initialize and add Contact Picker View
	self.contactPickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
	self.contactPickerView.delegate = self;
	[self.contactPickerView setPlaceholderString:@"Type contact name"];
	[self.view addSubview:self.contactPickerView];
    
	// Fill the rest of the view with the table view
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight) style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    
	[self.tableView registerNib:[UINib nibWithNibName:@"THContactPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    
	[self.view insertSubview:self.tableView belowSubview:self.contactPickerView];
    
	searchResultSections = [[NSMutableArray alloc] init];
	NSMutableArray *sections = [[NSMutableArray alloc] init];
	CPTableSection *tableSection = [[CPTableSection alloc] init];
	tableSection.name = @"iOS Developers";
	CPTableSection *tableSection1 = [[CPTableSection alloc] init];
	tableSection1.name = @"Dot Net Developers";
	CPTableSection *tableSection2 = [[CPTableSection alloc] init];
	tableSection2.name = @"Club";
    
	CPContact *contact = [[CPContact alloc] init];
	contact.name = @"Asif Noor";
	//contact.email = @"asef.noor@gmail.com";
    
	CPContact *contact1 = [[CPContact alloc] init];
	contact1.name = @"Shoaib Ahmad";
	contact1.email = @"shoaib.ahmad@gmail.com";
    
	CPContact *contact2 = [[CPContact alloc] init];
	contact2.name = @"Asif Noor";
	contact2.email = @"asif.noor@gmail.com";
    
	CPContact *contact3 = [[CPContact alloc] init];
	contact3.name = @"Shoaib";
	contact3.email = @"shoaib@gmail.com";
    
	CPContact *contact4 = [[CPContact alloc] init];
	contact4.name = @"Shoaib";
	contact4.email = @"shoaib.Tandon@gmail.com";
    
	CPContact *contact5 = [[CPContact alloc] init];
	contact5.name = @"Shoaib Singh";
	contact5.email = @"shoaib.Tandon@gmail.com";
    contact5.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    
	[tableSection.contacts addObjectsFromArray:@[contact, contact1, contact2]];
	[tableSection1.contacts addObjectsFromArray:@[contact3, contact4, contact5]];
	[sections addObjectsFromArray:@[tableSection, tableSection1]];
    
    
	[self setup:sections];
}

- (void)toggleAllContactsSelection:(UIBarButtonItem *)sender {
	if ([[sender image] isEqual:[UIImage imageNamed:UnSelectedImage]]) {
		[sender setImage:[UIImage imageNamed:SelectedImage]];
		NSArray *sectionContacts = [self contactsInSections:self.tableSections];
		for (CPContact *contact in sectionContacts) {
			if (![[self.selectedContacts valueForKeyPath:@"@distinctUnionOfObjects.email"] containsObject:contact.email]) {
				[self.selectedContacts addObject:contact];
				[self.contactPickerView addContact:contact withName:contact.email];
			}
		}
	}
	else {
		[sender setImage:[UIImage imageNamed:UnSelectedImage]];
		[self removeAllContacts:nil];
	}
    
	// Set checkbox to "selected"
	// Enable Done button if total selected contacts > 0
	if (self.selectedContacts.count > 0) {
		barButton.enabled = TRUE;
	}
	else {
		barButton.enabled = FALSE;
	}
	self.title = [NSString stringWithFormat:_headerTitle, (unsigned long)self.selectedContacts.count];
	[self.tableView reloadData];
}

- (void)setup:(NSMutableArray *)sectionList {
	NSArray *allContacts = [self contactsInSections:sectionList];
	for (CPContact *contact in allContacts) {
		if (contact.image != nil) {
			isDisplayContactImage = true;
			break;
		}
	}
	self.selectedContacts = [NSMutableArray array];
	self.tableSections = [NSArray arrayWithArray:sectionList];
	self.filteredSectionsWithContacts = [NSMutableArray array];
	self.filteredSectionsWithContacts = self.tableSections;
	[self.tableView reloadData];
}

- (NSArray *)contactsInSections:(NSArray *)sections {
	NSMutableArray *allContacts = [[NSMutableArray alloc] init];
    
	for (CPTableSection *section in sections) {
		[allContacts addObjectsFromArray:section.contacts];
	}
	return [allContacts copy];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	CGFloat topOffset = 0;
	if ([self respondsToSelector:@selector(topLayoutGuide)]) {
		topOffset = self.topLayoutGuide.length;
	}
	CGRect frame = self.contactPickerView.frame;
	frame.origin.y = topOffset;
	self.contactPickerView.frame = frame;
	[self adjustTableViewFrame:NO];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)adjustTableViewFrame:(BOOL)animated {
	CGRect frame = self.tableView.frame;
	// This places the table view right under the text field
	frame.origin.y = self.contactPickerView.frame.size.height;
	// Calculate the remaining distance
	frame.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight;
    
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelay:0.1];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		self.tableView.frame = frame;
		[UIView commitAnimations];
	}
	else {
		self.tableView.frame = frame;
	}
}

#pragma mark - UITableView Delegate and Datasource functions
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return ((CPTableSection *)[self.filteredSectionsWithContacts objectAtIndex:section]).name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.filteredSectionsWithContacts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [((CPTableSection *)[self.filteredSectionsWithContacts objectAtIndex:section]).contacts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Get the desired contact from the filteredContacts array
    
	CPContact *contact =  (CPContact *)[((CPTableSection *)[self.filteredSectionsWithContacts objectAtIndex:indexPath.section]).contacts objectAtIndex : indexPath.row];
    
	// Initialize the table view cell
	NSString *cellIdentifier = @"ContactCell";
	THContactPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	// Get the UI elements in the cell;
	UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    
	if (!isDisplayContactImage) {
		cell.contactImageView.hidden = TRUE;
		[cell refreshLayoutWithoutImage];
	}else{
        cell.contactImageView.hidden = FALSE;
        cell.contactImageView.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
	// Assign values to to US elements
	cell.fullNameLabel.text = contact.name;
	cell.emailLabel.text = contact.email;
	//    if(contact.image) {
	//        contactImage.image = contact.image;
	//    }
	//    contactImage.layer.masksToBounds = YES;
	//    contactImage.layer.cornerRadius = 20;
	//
	// Set the checked state for the contact selection checkbox
	if ([contact.email length] == 0 || contact.email == nil) {
		cell.userInteractionEnabled = FALSE;
		cell.fullNameLabel.alpha = 0.5f;
		cell.alpha = 0.5f;
	}
	UIImage *image;
	//    if ([self.selectedContacts containsObject:[self.filteredContacts objectAtIndex:indexPath.row]]){
	if ([[self.selectedContacts valueForKeyPath:@"@distinctUnionOfObjects.email"] containsObject:contact.email]) {
		//cell.accessoryType = UITableViewCellAccessoryCheckmark;
		image = [UIImage imageNamed:SelectedImage];
	}
	else {
		//cell.accessoryType = UITableViewCellAccessoryNone;
		image = [UIImage imageNamed:UnSelectedImage];
	}
	checkboxImageView.image = image;
	//
	//    // Assign a UIButton to the accessoryView cell property
	//    cell.accessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	//    // Set a target and selector for the accessoryView UIControlEventTouchUpInside
	//    [(UIButton *)cell.accessoryView addTarget:self action:@selector(viewContactDetail:) forControlEvents:UIControlEventTouchUpInside];
	//    cell.accessoryView.tag = contact.recordId; //so we know which ABRecord in the IBAction method
    
    
    
	return cell;
}

- (struct ContactIndexPath)indexPathOfContactInTable:(id)contact {
	struct ContactIndexPath contactIndexPath;
	for (int i = 0; i < [self.filteredSectionsWithContacts count]; i++) {
		CPTableSection *section = [self.filteredSectionsWithContacts objectAtIndex:i];
		int contactIndexInSection = [section.contacts indexOfObject:contact];
		if (contactIndexInSection != NSNotFound) {
			contactIndexPath.sectionNumber = i;
			contactIndexPath.rowNumber = contactIndexInSection;
			return contactIndexPath;
		}
	}
	//if not found then row and section 0,0
	contactIndexPath.sectionNumber = -1;
	contactIndexPath.rowNumber = -1;
	return contactIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Hide Keyboard
	[self.contactPickerView resignKeyboard];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
	// This uses the custom cellView
	// Set the custom imageView
	CPContact *contact =  (CPContact *)[((CPTableSection *)[self.filteredSectionsWithContacts objectAtIndex:indexPath.section]).contacts objectAtIndex : indexPath.row];
    
    
	//Contact *user = [self.filteredContacts objectAtIndex:indexPath.row];
	UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
	UIImage *image;
    
	if ([[self.selectedContacts valueForKeyPath:@"@distinctUnionOfObjects.email"] containsObject:contact.email]) { // contact is already selected so remove it from ContactPickerView
		[self.selectedContacts removeObject:contact];
		[self.contactPickerView removeContact:contact];
		// Set checkbox to "unselected"
		image = [UIImage imageNamed:UnSelectedImage];
	}
	else {
		// Contact has not been selected, add it to THContactPickerView
		[self.selectedContacts addObject:contact];
		[self.contactPickerView addContact:contact withName:contact.email];
		// Set checkbox to "selected"
		image = [UIImage imageNamed:SelectedImage];
	}
    
	// Enable Done button if total selected contacts > 0
	if (self.selectedContacts.count > 0) {
		barButton.enabled = TRUE;
	}
	else {
		barButton.enabled = FALSE;
	}
    
	NSArray *totalContacts = [self contactsInSections:self.filteredSectionsWithContacts];
	if ([self.selectedContacts count] >= [[totalContacts valueForKeyPath:@"@distinctUnionOfObjects.email"] count]) {
		[toggleContactSelectionBarItem setImage:[UIImage imageNamed:SelectedImage]];
	}
	else {
		[toggleContactSelectionBarItem setImage:[UIImage imageNamed:UnSelectedImage]];
	}
	// Update window title
	self.title = [NSString stringWithFormat:_headerTitle, (unsigned long)self.selectedContacts.count];
    
	// Set checkbox imagei
	checkboxImageView.image = image;
	// Reset the filtered contacts
	self.filteredSectionsWithContacts = self.tableSections;
	// Refresh the tableview
	[self.tableView reloadData];
}

#pragma mark - THContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
	if ([textViewText rangeOfString:@"\n"].location != NSNotFound) {
		NSLog(@"newline found");
	}
	[searchResultSections removeAllObjects];
	if ([textViewText isEqualToString:@""]) {
		[self.contactPickerView resignKeyboard];
		self.filteredSectionsWithContacts = self.tableSections;
	}
	else if ([textViewText rangeOfString:@","].location != NSNotFound ||
	         [textViewText rangeOfString:@";"].location != NSNotFound ||
	         [textViewText rangeOfString:@" "].location != NSNotFound ||
	         [textViewText rangeOfString:@"\n"].location != NSNotFound) {
		NSString *email;
		if ([textViewText rangeOfString:@","].location != NSNotFound) {
			email = [textViewText stringByReplacingOccurrencesOfString:@"," withString:@""];
		}
		else if ([textViewText rangeOfString:@";"].location != NSNotFound) {
			email = [textViewText stringByReplacingOccurrencesOfString:@";" withString:@""];
		}
		else if ([textViewText rangeOfString:@" "].location != NSNotFound) {
			email = [textViewText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		}
		else {
			email = [textViewText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		}
		if ([email length] == 0) {
			[self.contactPickerView removeEmailText];
			return;
		}
		if ([self isValidEmail:email]) {
			CPContact *contact = [[CPContact alloc] init];
			contact.name = @"";
			contact.email = email;
			[self addContactEmailToCollection:contact];
		}
		else {
			[self showAlertWithTitle:@"" message:@"Invalid Email."];
		}
	}
	else {
		for (CPTableSection *section in self.tableSections) {
			CPTableSection *modifiedSection = [[CPTableSection alloc] init];
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@ OR self.%@ contains[cd] %@", @"name", textViewText, @"email", textViewText];
			if ([[section.contacts filteredArrayUsingPredicate:predicate] count] > 0) {
				modifiedSection.name = section.name;
				modifiedSection.contacts = [NSMutableArray arrayWithArray:[section.contacts filteredArrayUsingPredicate:predicate]];
				[searchResultSections addObject:modifiedSection];
			}
		}
		self.filteredSectionsWithContacts = [NSArray arrayWithArray:searchResultSections];
	}
	[self.tableView reloadData];
}

- (void)addContactEmailToCollection:(CPContact *)contact {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@ ", @"email", contact.email];
	NSArray *contacts = [self.selectedContacts filteredArrayUsingPredicate:predicate];
    
	if ([contacts count] > 0) { // contact is already selected so remove it from ContactPickerView
		// Set checkbox to "unselected"
		[self showAlertWithTitle:@"" message:@"Contact already added in list.!"];
		[self.contactPickerView removeEmailText];
	}
	else {
		// Contact has not been selected, add it to THContactPickerView
		[self.selectedContacts addObject:contact];
		[self.contactPickerView addContact:contact withName:contact.email];
		self.title = [NSString stringWithFormat:_headerTitle, (unsigned long)self.selectedContacts.count];
		self.filteredSectionsWithContacts = self.tableSections;
		[self.tableView reloadData];
	}
	if (self.selectedContacts.count > 0) {
		barButton.enabled = TRUE;
	}
	else {
		barButton.enabled = FALSE;
	}
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
	[self adjustTableViewFrame:YES];
}

- (void)contactPickerDidRemoveContact:(id)contact {
	[self.selectedContacts removeObject:contact];
	struct ContactIndexPath indexPath = [self indexPathOfContactInTable:contact];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.rowNumber inSection:indexPath.sectionNumber]];
	// Enable Done button if total selected contacts > 0
	if (self.selectedContacts.count > 0) {
		barButton.enabled = TRUE;
	}
	else {
		barButton.enabled = FALSE;
	}
    
	// Set unchecked image
	UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
	UIImage *image;
	image = [UIImage imageNamed:UnSelectedImage];
	checkboxImageView.image = image;
    
	// Update window title
	self.title = [NSString stringWithFormat:_headerTitle, (unsigned long)self.selectedContacts.count];
	NSArray *totalContacts = [self contactsInSections:self.filteredSectionsWithContacts];
	if ([self.selectedContacts count] >= [totalContacts count]) {
		[toggleContactSelectionBarItem setImage:[UIImage imageNamed:SelectedImage]];
	}
	else {
		[toggleContactSelectionBarItem setImage:[UIImage imageNamed:UnSelectedImage]];
	}
	self.filteredSectionsWithContacts = self.tableSections;
	[self.tableView reloadData];
}

- (void)removeAllContacts:(id)sender {
	[self.contactPickerView removeAllContacts];
	[self.selectedContacts removeAllObjects];
	[self.tableView reloadData];
}

- (void)done:(id)sender {
	[self.tableView resignFirstResponder];
    
	if (_getSelectedContactsCallback) {
		_getSelectedContactsCallback([self.selectedContacts copy]);
	}
    
	[self dismissMe];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
	                                                    message:message
	                                                   delegate:nil
	                                          cancelButtonTitle:@"Ok"
	                                          otherButtonTitles:nil];
	[alertView show];
}

- (BOOL)isValidEmail:(NSString *)checkString {
	BOOL stricterFilter = YES; //
	NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
	NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:checkString];
}

#pragma mark -modal controller functions
- (void)presentMeInViewController:(UIViewController *)parentVC {
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self];
	nc.modalPresentationStyle = UIModalPresentationFormSheet;
    
	// Present view controller
	//
	if ([parentVC respondsToSelector:@selector(presentViewController:animated:completion:)]) {
		[parentVC presentViewController:nc animated:YES completion:nil];
	}
    
	presented = TRUE;
}

- (void)dismissMe {
	[self dismissViewControllerAnimated:YES completion:nil];
	presented = FALSE;
}

- (void)popMe {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
