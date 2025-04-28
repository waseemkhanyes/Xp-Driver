//
//  DatePickerViewController.m
//  XPDriver
//
//  Created by Syed zia on 15/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()
@property (strong, nonatomic)  NSDate *selectedDate;
@property (strong, nonatomic)  NSString *dateFormate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)confirmButtonPressed:(UIBarButtonItem *)sender;

@end
@implementation DatePickerViewController
@synthesize delegate;
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *todaysDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *minDateComponents = [[NSDateComponents alloc] init];
    NSDateComponents *maxDateComponents = [[NSDateComponents alloc] init];
    
    if (self.isExpiryDate) {
         [maxDateComponents setYear:+20];
        NSDate *minDate = [gregorian dateByAddingComponents:minDateComponents toDate:todaysDate  options:0];
       NSDate *maxDate = [gregorian dateByAddingComponents:maxDateComponents toDate:todaysDate  options:0];
        self.datePicker.maximumDate = maxDate;
        self.datePicker.minimumDate = minDate;
    }else if (self.isDOB){
        [minDateComponents setYear:-70];
        [maxDateComponents setYear:-18];
        NSDate *minDate = [gregorian dateByAddingComponents:minDateComponents toDate:todaysDate  options:0];
        NSDate *maxDate = [gregorian dateByAddingComponents:maxDateComponents toDate:todaysDate  options:0];
        
        self.datePicker.maximumDate = maxDate;
        self.datePicker.minimumDate = minDate;
    }else  {
        self.datePicker.minimumDate = self.isToday ? [NSDate date] : [NSDate tomorrowDate];
        
    }
  self.datePicker.datePickerMode = self.DatePickerMode;
    if (self.pickerDate) {
        self.datePicker.date = self.pickerDate;
    }
    // Do any additional setup after loading the view.
}

- (NSDate *)selectedDate{
    NSDate *chosneDate = [self.datePicker date];
    return chosneDate;
}
- (NSString *)dateFormate{
    if (self.isDOB || self.isExpiryDate) {
        return DATE_ONLY;
    }
    return  self.DatePickerMode == UIDatePickerModeTime ? TIME_ONLY : DATE_TIME_DISPLAY;
}
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmButtonPressed:(UIBarButtonItem *)sender {
    NSString *dateString = [NSDate stringFromDate:self.selectedDate withFormat:self.dateFormate];
    [self.delegate dismissWithDateOrTime:dateString];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
