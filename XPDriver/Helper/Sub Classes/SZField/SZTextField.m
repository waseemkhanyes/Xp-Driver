//
//  SZTextField.m
//  XPEats
//
//  Created by Macbook on 29/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//

#import "SZTextField.h"
@interface SZTextField()< UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSArray* monthArray;
@property (strong, nonatomic) NSNumber* selectedMonth;
@property (strong, nonatomic) NSNumber* selectedYear;
@property (strong, nonatomic) UIPickerView *expirationDatePicker;
@property (strong, nonatomic) UIToolbar *pickerToolbar;
@end
@implementation SZTextField
#pragma mark :- Drawing Methods
-(void)drawRect:(CGRect)rect {
    [self updateTextField:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(rect), CGRectGetHeight(rect))];
}

#pragma mark :- Loading From NIB
-(void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
}

#pragma mark :- Initialization Methods
-(instancetype)init {
    if (self) {
        self = [super init];
        [self initialization];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        [self initialization];
    }
    return self;
}
#pragma mark  Update and Manage Subviews
-(void)updateTextField:(CGRect )frame {
    
    self.frame = frame;
    [self initialization];
}
- (void)setIsLeftPading:(BOOL)isLeftPading{
    _isLeftPading = isLeftPading;
    [self addLeftPading] ;
}
- (void)setCornnerRadius:(float)cornnerRadius{
    _cornnerRadius = cornnerRadius;
    self.layer.cornerRadius = cornnerRadius;
    self.layer.masksToBounds = YES;
}
- (void)setMode:(int)mode{
    _mode = mode;
    [self initialization];
}
#pragma mark  Intialization method
-(void)initialization{
    [self configurePickerView];
   // self.inputAccessoryView = self.pickerToolbar;
    switch (self.mode) {
        case Card:
            self.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case Date:

//            self.autocapitalizationType = UITextAutocapitalizationTypeNone;
//            self.keyboardType = UIKeyboardTypeNumberPad;
            self.inputView = nil;
            self.inputView = self.expirationDatePicker;
            break;
        case CVC:
            self.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }
}
- (void)configurePickerView {
    self.monthArray = MONTH_ARRAY;
    self.expirationDatePicker = [[UIPickerView alloc] init];
    self.expirationDatePicker.delegate = self;
    self.expirationDatePicker.dataSource = self;
    self.expirationDatePicker.showsSelectionIndicator = YES;
    
    //Create and configure toolabr that holds "Done button"
    self.pickerToolbar = [[UIToolbar alloc] init];
    self.pickerToolbar .barStyle = UIBarStyleBlackTranslucent;
    [self.pickerToolbar  setTintColor:[UIColor whiteColor]];
    [self.pickerToolbar  sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    [self.pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
}
- (void)pickerDoneButtonPressed {
    [self resignFirstResponder];
}


#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (component == 0) ? 12 : 10;
}

#pragma mark - UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        //Expiration month
        return self.monthArray[row];
    }
    else {
        //Expiration year
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        return [NSString stringWithFormat:@"%ld",currentYear + row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.selectedMonth = @(row + 1);
    }
    else {
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:row forComponent:1];
        self.selectedYear = @([yearString integerValue]);
    }
    
    
    if (!self.selectedMonth) {
        [self.expirationDatePicker selectRow:0 inComponent:0 animated:YES];
        self.selectedMonth = @(1); //Default to January if no selection
    }
    
    if (!self.selectedYear) {
        [self.expirationDatePicker selectRow:0 inComponent:1 animated:YES];
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:0 forComponent:1];
        self.selectedYear = @([yearString integerValue]); //Default to current year if no selection
    }
    self.text = [NSString stringWithFormat:@"%@/%@", self.selectedMonth, self.selectedYear];
}

@end
