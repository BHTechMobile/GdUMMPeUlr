//
//  SelectDateViewController.m
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "SelectDateViewController.h"

@interface SelectDateViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation SelectDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.title = @"Select Date";
    
    self.dateFormater =  [[NSDateFormatter alloc] init];
    [_dateFormater setDateStyle:NSDateFormatterMediumStyle];
    
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    _dateTxtField.inputView = _datePicker;
    _timeTextField.inputView = _pickerView;
    _datePicker.minimumDate = [NSDate date];
    if(_selectedDate)
    {
        _datePicker.date = _selectedDate;
        _dateTxtField.text = [_dateFormater stringFromDate:_selectedDate];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:_selectedDate];
        NSInteger hour = [components hour] ;
        NSInteger minute = [components minute];
        if(hour>=8 && hour <=16) [_pickerView selectRow:(hour-8) inComponent:0 animated:NO];
        else hour = 8;
        if(minute == 30) [_pickerView selectRow:1 inComponent:1 animated:NO];
        else minute = 0;
        [_timeTextField setText:[NSString stringWithFormat:@"%d:%02d",hour,minute]];
        
    }else
    {
        _datePicker.date = [NSDate date];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_dateTxtField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done:(id)sender
{
    if([_dateTxtField.text isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have not choose date yet!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if([_timeTextField.text isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have not choose time yet!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(selectedDate:)])
    {
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        
        NSCalendar * cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [cal components:unitFlags fromDate:_datePicker.date];
        int firstComponetRow = [_pickerView selectedRowInComponent:0];
        int secondComponetRow = [_pickerView selectedRowInComponent:1];
        [comps setHour:firstComponetRow+8];
        [comps setMinute:secondComponetRow*30];
        NSDate* date = [cal dateFromComponents:comps];
        if([date timeIntervalSinceNow]<=0)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have to choose time in future" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        self.selectedDate = date;
        [_delegate selectedDate:_selectedDate];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

#pragma mark - UIPickerView Datasource

-(int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return 9;
    else
        return 2;
}

-(int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
        return [NSString stringWithFormat:@"%d",row+8];
    else
        return [NSString stringWithFormat:@"%d",row*30];
}

#pragma mark - UIPickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int firstComponetRow = [pickerView selectedRowInComponent:0];
    int secondComponetRow = [pickerView selectedRowInComponent:1];
    NSString* hourStr = [NSString stringWithFormat:@"%d",firstComponetRow+8];
    NSString* minuteStr = [NSString stringWithFormat:@"%02d",secondComponetRow*30];
    [_timeTextField setText:[NSString stringWithFormat:@"%@:%@",hourStr,minuteStr]];
    NSLog(@"Time change");
}

-(float)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 80;
}

#pragma mark - UIDatePicker change

- (IBAction)dateChange:(id)sender
{
    NSString* dateStr = [_dateFormater stringFromDate:_datePicker.date];
    [_dateTxtField setText:dateStr];
    NSLog(@"Date Change");
}



@end
