//
//  SelectDateViewController.h
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelecteDateVCDelegate;
@interface SelectDateViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UITextField *dateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) id<SelecteDateVCDelegate> delegate;
@property (strong, nonatomic) NSDateFormatter* dateFormater;

@end

@protocol SelecteDateVCDelegate <NSObject>

-(void)selectedDate:(NSDate*)date;

@end