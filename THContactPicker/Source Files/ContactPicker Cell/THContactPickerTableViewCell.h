//
//  THContactPickerTableViewCell.h
//  ContactPicker
//
//  Created by Mac on 3/27/14.
//  Copyright (c) 2014 Tristan Himmelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THContactPickerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
-(void)refreshLayoutWithoutImage;
@end
