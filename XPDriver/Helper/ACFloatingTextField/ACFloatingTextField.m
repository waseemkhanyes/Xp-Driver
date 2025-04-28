//
//  AppTextField.m
//  TFDemoApp
//
//  Created by Abhishek Chandani on 19/05/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//
#import <objc/runtime.h>
#import "City.h"
#import "State.h"
#import "ACFloatingTextField.h"
#define kPlaceholderFontSize 12

#define kPlaceholderFontSize 12
#define kPlaceholderHeight 13
#define ACCOUNT_TYPES @[PLEASE_SELECT,@"Individual",@"Business"]
#import "ACFloatingTextField.h"
@interface ACFloatingTextField ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NSLayoutConstraint *bottomLineViewHeight;
    NSLayoutConstraint *placeholderLabelHeight;
    NSLayoutConstraint *errorLabelHieght;
    
}

@property (nonatomic,strong) NSMutableArray *vehicleTypes;
@property (nonatomic,strong) NSMutableArray *vehicleModels;
@property (nonatomic,strong) NSMutableArray *states;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;
@end
@implementation ACFloatingTextField

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

#pragma mark :- Drawing Text Rect
- (CGRect)textRectForBounds:(CGRect)bounds {
    if (self.mode == Phone || self.mode == KCurrency) {
        return CGRectMake(85, 4, bounds.size.width, bounds.size.height);
    }
    return CGRectMake(4, 4, bounds.size.width, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.mode == Phone || self.mode == KCurrency) {
        return CGRectMake(85, 4, bounds.size.width, bounds.size.height);
    }
    return CGRectMake(4, 4, bounds.size.width, bounds.size.height);
}

#pragma mark  Override Set text
-(void)setText:(NSString *)text {
    if (text) {
        [self floatTheLabel];
    }
    if (showingError) {
        [self hideErrorPlaceHolder];
    }
    [super setText:text];
}

#pragma mark  Set Placeholder Text On Label
-(void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    if (![placeholder isEqualToString:@""]) {
        self.labelPlaceholder.text = placeholder;
    }
    
}
#pragma mark  Set Currency
-(void)setSelectedCurrency:(NSString *)selectedCurrency{
    _selectedCurrency = selectedCurrency;
    self.isVaild = !selectedCurrency.isEmpty && selectedCurrency != nil;
 //    [self addCountryCodeLabel];
}

#pragma mark  Set Error Text On Label
-(void)setErrorText:(NSString *)errorText {
    _errorText = errorText;
    self.labelErrorPlaceholder.text = errorText;
}
#pragma mark  Set Selected Date
-(void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    [self.datePicker setDate:_selectedDate];
}
-(void)setErrorTextColor:(UIColor *)errorTextColor {
    _errorTextColor = errorTextColor;
    self.labelErrorPlaceholder.textColor = _errorTextColor;
}
-(void)setErrorLineColor:(UIColor *)errorLineColor {
    _errorLineColor = errorLineColor;
    [self floatTheLabel];
}
-(void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self floatTheLabel];
}

-(void)setSelectedLineColor:(UIColor *)selectedLineColor {
    _selectedLineColor = selectedLineColor;
    [self floatTheLabel];
}

-(void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    [self floatTheLabel];
}

-(void)setSelectedPlaceHolderColor:(UIColor *)selectedPlaceHolderColor {
    _selectedPlaceHolderColor = selectedPlaceHolderColor;
    [self floatTheLabel];
}

- (void)setMode:(int)mode{
    _mode = mode;
    [self keyboardSetup];
    if (_mode == Password) {
        [self addEyeButton];
    }else if (_mode == KCurrency){
        self.currencies       = SHAREMANAGER.appData.currencies;
        
        NSArray *filteredArray = [self.currencies  filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
            Currency *cu = (Currency *)object;
            return [cu.name isEqualToString:@"CAD"] || [cu.name isEqualToString:@"USD"];
        }]];
        self.currencies  = [NSMutableArray arrayWithArray:filteredArray];
        if (![self.currencies containsObject:PLEASE_SELECT]) {
            [self.currencies insertObject:PLEASE_SELECT atIndex:0];
        }
        Currency *currency = self.currencies[1];
        self.selectedCurrency = currency.name;
        [self setText:self.selectedCurrency];
        if (SHAREMANAGER.user != nil && SHAREMANAGER.user.currency != nil) {
                self.selectedCurrency = SHAREMANAGER.user.currency;
            [self setText:self.selectedCurrency];
        }
       
        
        [self addCountryCodeLabel];
    }
    self.leadingConstraint.constant = (self.mode == Phone || self.mode == KCurrency) ? 85 : 5;
}
#pragma mark  Intialization method
-(void)initialization{
    
    self.clipsToBounds = true;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.mode == AppState) {
            self.states    = SHAREMANAGER.appData.country.states;
            if (![self.states containsObject:PLEASE_SELECT]) {
                [self.states insertObject:PLEASE_SELECT atIndex:0];
            }
            
        }
        if (self.mode == KCurrency) {
            self.currencies       = SHAREMANAGER.appData.currencies;
            NSArray *filteredArray = [self.currencies  filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
                Currency *cu = (Currency *)object;
                return [cu.name isEqualToString:@"CAD"] || [cu.name isEqualToString:@"USD"];
            }]];
            self.currencies  = [NSMutableArray arrayWithArray:filteredArray];
            if (![self.currencies containsObject:PLEASE_SELECT]) {
                [self.currencies insertObject:PLEASE_SELECT atIndex:0];
            }
            if (SHAREMANAGER.user != nil) {
                self.selectedCurrency = SHAREMANAGER.user.currency;

            }else{
                Currency *currency = self.currencies[1];
                 self.selectedCurrency = currency.name;
            }
        }
        if (self.mode == CarType) {
          self.vehicleTypes = [VehicleManager share].carTypres;
        }
       
       
       
    });
   
   
    //VARIABLE INITIALIZATIONS
    
    //1. Placeholder Color.
    if (_placeHolderColor == nil){
        _placeHolderColor = [UIColor lightGrayColor];
    }
    
    //2. Placeholder Color When Selected.
    if (_selectedPlaceHolderColor==nil) {
        _selectedPlaceHolderColor = [UIColor colorWithRed:19/256.0 green:141/256.0 blue:117/256.0 alpha:1.0];
    }
    
    //3. Bottom line Color.
    if (_lineColor==nil) {
        _lineColor = [UIColor blackColor];
    }
    
    //4. Bottom line Color When Selected.
    if (_selectedLineColor==nil) {
        _selectedLineColor = [UIColor colorWithRed:19/256.0 green:141/256.0 blue:117/256.0 alpha:1.0];
    }
    
    //5. Bottom line error Color.
    if (_errorLineColor==nil) {
        _errorLineColor = [UIColor redColor];
    }
    
    //6. Bottom place Color When show error.
    if (_errorTextColor==nil) {
        _errorTextColor = [UIColor redColor];
    }
    
    /// Adding Bottom Line View.
    [self addBottomLineView];
    
    /// Adding Placeholder Label.
    [self addPlaceholderLabel];
    [self addErrorPlaceholderLabel];
    [self setPlaceholderColor];
    /// Placeholder Label Configuration.
    if (![self.text isEqualToString:@""]){
        [self floatTheLabel];
    }
    if (self.isDropDown) {
        [self addDropdownIconToRightView];
    }
    [self setFont:[UIFont normal]];
    //[self addLeftPading];
    [self keyboardSetup];
}

- (void)keyboardSetup{
    switch (self.mode) {
        case Name:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case Password:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case Email:
            self.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case Phone:
            self.keyboardType = UIKeyboardTypePhonePad;
            break;
        case AppState:
            self.inputView = nil;
            self.inputView = [self pickerView];
             [self reloadInputViews];
            break;
        case AppCity:
            self.inputView = nil;
            self.inputView = [self pickerView];
            [self reloadInputViews];
            break;
        case KCurrency:
            self.inputView = nil;
            self.inputView = [self pickerView];
            [self reloadInputViews];
            break;
        case CNIC:
            self.keyboardType = UIKeyboardTypePhonePad;
            break;
        case License:
            self.keyboardType = UIKeyboardTypeDefault;
           break;
        case Routing:
            self.keyboardType = UIKeyboardTypeDefault;
          //  self.inputAccessoryView = [self toolbar];
            break;
        case CarType:
            self.inputView = nil;
            self.inputView = [self pickerView];
            [self reloadInputViews];
            break;
        case Manufacturer:
             self.keyboardType = UIKeyboardTypeDefault;
            break;
        case CarModels:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case Power:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case CarModelYear:
            self.inputView = nil;
            self.inputView = [self pickerView];
            [self reloadInputViews];
            break;
        case Colors:
            self.inputView = nil;
            self.inputView = [self pickerView];
            [self reloadInputViews];
            break;
        case AccountType:
            self.inputView = nil;
            self.inputView = [self pickerView];
            [self reloadInputViews];
            break;
        case DOB:
            self.inputView = nil;
            self.inputView = [self datePicker];
            [self reloadInputViews];
            break;
       case Expiry:
            self.inputView = nil;
            self.inputView = [self datePicker];
            [self reloadInputViews];
            break;
        case Transit:
           self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case Institution:
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case AccountNumber:
        self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }
}
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    int index = [SHAREMANAGER.appData indexOfCurrency:self.selectedCurrency];
    [_pickerView selectRow:index + 1 inComponent:0 animated:false];
    return _pickerView;
}
- (void)setPlaceholderColor{
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self, ivar);
    placeholderLabel.textColor = self.placeHolderColor;
}
- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]init];
        [_datePicker setBackgroundColor:[UIColor whiteColor]];
        [_datePicker setTintColor:[UIColor whiteColor]];
        [_datePicker setDate:!self.selectedDate ? [NSDate date] : self.selectedDate];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CA"];
        [_datePicker setLocale:locale];
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle  = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
        NSDate *todaysDate = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *minDateComponents = [[NSDateComponents alloc] init];
        NSDateComponents *maxDateComponents = [[NSDateComponents alloc] init];
        if (self.mode == Expiry) {
            [maxDateComponents setYear:+6];
            NSDate *minDate = [gregorian dateByAddingComponents:minDateComponents toDate:todaysDate  options:0];
            NSDate *maxDate = [gregorian dateByAddingComponents:maxDateComponents toDate:todaysDate  options:0];
            _datePicker.maximumDate = maxDate;
            _datePicker.minimumDate = minDate;
        }
        else if (self.mode == DOB){
            [minDateComponents setYear:-70];
            [maxDateComponents setYear:-0];
            NSDate *minDate = [gregorian dateByAddingComponents:minDateComponents toDate:todaysDate  options:0];
            NSDate *maxDate = [gregorian dateByAddingComponents:maxDateComponents toDate:todaysDate  options:0];
            
            _datePicker.maximumDate = maxDate;
            _datePicker.minimumDate = minDate;
        }
        else  {
            _datePicker.minimumDate = self.isToday ? [NSDate date] : [NSDate tomorrowDate];
            
        }
        if (self.mode == DOB) {
            _datePicker.datePickerMode = UIDatePickerModeDate;
        }else if ( self.mode == Expiry){
            _datePicker.datePickerMode = UIDatePickerModeDate;
        }
        [_datePicker addTarget:self action:@selector(updateDateTextField) forControlEvents:UIControlEventValueChanged];
        if (@available(iOS 13.0, *)) {
            _datePicker.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
    }
    return _datePicker;
}
-(void)updateDateTextField{
    self.selectedDate = _datePicker.date;
    if (self.mode == Expiry) {
        NSString *dateString = [NSDate stringFromDate:self.selectedDate withFormat:DATE_TIME_DISPLAY];
        NSDate *selectedData = [NSDate dateFromString:dateString withFormat:DATE_TIME_DISPLAY];
        [self setText:[NSDate stringFromDate:selectedData withFormat:DATE_TIME_DISPLAY]];
    }else{
    NSString *dateString = [NSDate stringFromDate:self.selectedDate withFormat:self.dateFormate];
    NSDate *selectedData = [NSDate dateFromString:dateString withFormat:DATE_ONLY];
    [self setText:[NSDate stringFromDate:selectedData withFormat:DATE_ONLY_DISPLAY]];
    }
    
}
#pragma mark :- Private Methods
-(void)addBottomLineView{
    
    if (bottomLineView.superview != nil) {
        return;
    }
    bottomLineView = [UIView new];
    bottomLineView.backgroundColor = showingError ? self.errorLineColor : self.lineColor;
    bottomLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomLineView];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    NSLayoutConstraint * bottomConstraint = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    bottomLineViewHeight = [NSLayoutConstraint constraintWithItem:bottomLineView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute: NSLayoutAttributeNotAnAttribute
                                                       multiplier:1
                                                         constant:1];
    
    [self addConstraints:@[leadingConstraint,trailingConstraint,bottomConstraint]];
    [bottomLineView addConstraint:bottomLineViewHeight];
    
    [self addTarget:self action:@selector(textfieldEditingChanged) forControlEvents:UIControlEventEditingChanged];
}
-(void)textfieldEditingChanged {
    if (showingError) {
        [self hideError];
    }
}
-(void)addPlaceholderLabel{
    _labelPlaceholder = [UILabel new];
    _labelPlaceholder.textAlignment = self.textAlignment;
    _labelPlaceholder.textColor = _placeHolderColor;
    _labelPlaceholder.text = self.placeholder;
    _labelPlaceholder.font = [UIFont small];
    _labelPlaceholder.hidden = YES;
    [_labelPlaceholder sizeToFit];
    _labelPlaceholder.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_labelPlaceholder];
    float xPostion = (self.mode == Phone || self.mode == KCurrency) ? 80 : 5;
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_labelPlaceholder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:2];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:_labelPlaceholder attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
     self.leadingConstraint = [NSLayoutConstraint constraintWithItem:_labelPlaceholder attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:xPostion];
    placeholderLabelHeight = [NSLayoutConstraint constraintWithItem:_labelPlaceholder
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute: NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:kPlaceholderHeight];
    
    [self addConstraints:@[topConstraint,trailingConstraint,self.leadingConstraint]];
    [_labelPlaceholder addConstraint:placeholderLabelHeight];
}

#pragma mark  Adding Error Label in textfield.
-(void)addErrorPlaceholderLabel{
    
    if (self.labelErrorPlaceholder.superview != nil){
        return;
    }
    
    self.labelErrorPlaceholder = [[UILabel alloc] init];
    self.labelErrorPlaceholder.text = self.errorText;
    self.labelErrorPlaceholder.textAlignment = self.textAlignment;
    self.labelErrorPlaceholder.textColor = self.errorTextColor;
    self.labelErrorPlaceholder.font = [UIFont normal];
    [self.labelErrorPlaceholder sizeToFit];
    self.labelErrorPlaceholder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.labelErrorPlaceholder];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.labelErrorPlaceholder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:2];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.labelErrorPlaceholder attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    errorLabelHieght = [NSLayoutConstraint constraintWithItem:self.labelErrorPlaceholder
                                                    attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil
                                                    attribute: NSLayoutAttributeNotAnAttribute
                                                   multiplier:1
                                                     constant:0];
    
    [self addConstraints:@[topConstraint,trailingConstraint]];
    [self.labelErrorPlaceholder addConstraint:errorLabelHieght];
    
}

#pragma mark  Method to show Error Label.
-(void)showErrorPlaceHolder{
    
    bottomLineViewHeight.constant = 2;
    if (self.errorText != nil && ![self.errorText isEqualToString:@""]) {
        errorLabelHieght.constant = kPlaceholderHeight;
        [UIView animateWithDuration:0.2 animations:^{
            bottomLineView.backgroundColor = _errorLineColor;
            [self layoutIfNeeded];
        }];
        
    }else{
        errorLabelHieght.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            bottomLineView.backgroundColor = _errorLineColor;
            [self layoutIfNeeded];
        }];
        
    }
    if (!self.disableShakeWithError) {
        [self shakeView:bottomLineView];
    }
}

#pragma mark  Method to Hide Error Label.
-(void)hideErrorPlaceHolder{
    showingError = NO;
    
    if (self.errorText == nil || [self.errorText isEqualToString:@""]) {
        return;
    }
    
    errorLabelHieght.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
       // self.rightView = nil;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark  Update and Manage Subviews
-(void)updateTextField:(CGRect )frame {
    
    self.frame = frame;
    [self initialization];
}

#pragma mark  Float UITextfield Placeholder Label.
-(void)floatPlaceHolder:(BOOL)selected {
    
    self.labelPlaceholder.hidden = NO;
    if (selected) {
        bottomLineView.backgroundColor = showingError ? self.errorLineColor : self.selectedLineColor;
        self.labelPlaceholder.textColor = self.selectedPlaceHolderColor;
        bottomLineViewHeight.constant = 2;
        [self setPlaceholderColor];
        
    }
    else{
        
        bottomLineView.backgroundColor = showingError ? self.errorLineColor : self.lineColor;
        self.labelPlaceholder.textColor = self.placeHolderColor;
        bottomLineViewHeight.constant = 1;
        [self setPlaceholderColor];
    }
    
    if (self.disableFloatingLabel){
        _labelPlaceholder.hidden = YES;
        //        [UIView animateWithDuration:0.2 animations:^{
        //            [self layoutIfNeeded];
        //        }];
        
        return;
    }
    
    // If already floated
    if (placeholderLabelHeight.constant == kPlaceholderHeight) {
        return;
    }
    
    
    placeholderLabelHeight.constant = kPlaceholderHeight;
    _labelPlaceholder.font = [UIFont normal];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    
}
-(void)resignPlaceholder{
    
    [self setPlaceholderColor];
    bottomLineView.backgroundColor = showingError ? self.errorLineColor : self.lineColor;
    bottomLineViewHeight.constant = 1;
    if (self.disableFloatingLabel){
        self.labelPlaceholder.hidden = YES;
        self.labelPlaceholder.textColor = self.placeHolderColor;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
        
        return;
    }
    CGFloat height = CGRectGetHeight(self.frame);
    placeholderLabelHeight.constant = height;
    [UIView animateWithDuration:0.3 animations:^{
        _labelPlaceholder.font = self.font;
        _labelPlaceholder.textColor = _placeHolderColor;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.labelPlaceholder.hidden = YES;
        self.placeholder = self.labelPlaceholder.text;
    }];
    
}
#pragma mark  UITextField Begin Editing.

-(void)textFieldDidBeginEditing {
    if (showingError) {
        [self hideErrorPlaceHolder];
    }
    if (!self.disableFloatingLabel) {
        self.placeholder = @"";
    }
    
    [self floatTheLabel];
    [self layoutSubviews];
}

#pragma mark  UITextField End Editing.
-(void)textFieldDidEndEditing {
    
    [self floatTheLabel];
    
}

#pragma mark  Float & Resign

-(void)floatTheLabel{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self.text isEqualToString:@""] && self.mode == Address) {
                  // [self floatPlaceHolder:YES];
        } else if ([self.text isEqualToString:@""] && self.isFirstResponder) {
            
            [self floatPlaceHolder:YES];
            
        }else if ([self.text isEqualToString:@""] && !self.isFirstResponder) {
            
            [self resignPlaceholder];
            
        }else if (![self.text isEqualToString:@""] && !self.isFirstResponder) {
            
            [self floatPlaceHolder:NO];
            
        }else if (![self.text isEqualToString:@""] && self.isFirstResponder) {
            
            [self floatPlaceHolder:YES];
        }
    });
    
}
#pragma mark  Shake Animation
-(void)shakeView:(UIView*)view{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.6;
    animation.values = @[@(-20.0), @20.0, @(-20.0), @20.0, @(-10.0), @10.0, @(-5.0), @(5.0), @(0.0) ];
    [view.layer addAnimation:animation forKey:@"shake"];
    
}
#pragma mark  Set Placeholder Text On Error Labels
-(void)showError {
    showingError = YES;
    [self showErrorWithText:@"Invalid information"];
}
-(void)hideError {
    showingError = false;
    [self hideErrorPlaceHolder];
    [self floatTheLabel];
}
-(void)showErrorWithText:(NSString *)errorText {
    _errorText = errorText;
    _labelErrorPlaceholder.text = errorText;
    showingError = YES;
    [self showErrorPlaceHolder];
}

#pragma mark  UITextField Responder Overide
-(BOOL)becomeFirstResponder {
    BOOL result = [super becomeFirstResponder];
    [self textFieldDidBeginEditing];
    return result;
}

-(BOOL)resignFirstResponder {
    BOOL result = [super resignFirstResponder];
    [self textFieldDidEndEditing];
    self.isVaild = [self isValidateField];
    return result;
}
-(BOOL)isValidateField{
    switch (self.mode) {
        case Name:
            [self showValidateResult:!fieldIsEmpty(self)];
            return !fieldIsEmpty(self);
            break;
        case Email:
            [self showValidateResult:[self validEmail:self.text]];
            return [self validEmail:self.text];
            break;
        case Password:
            [self showValidateResult:[self validPassword:self.text]];
            return [self validPassword:self.text];
        case Phone:
            [self showValidateResult:[self validPhone:self.text]];
            return [self validPhone:self.text];
        case Address:
            return ![self isEmpty];
        case AppState:
            return ![self isEmpty];
        case AppCity:
            return ![self isEmpty];
        case KCurrency:
            return ![self isEmpty];
        case CNIC:
            [self showValidateResult:[self validCNIC]];
            return [self validCNIC];
         case License:
            [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
            break;
        case Routing:
            [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
        case CarType:
             [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
        case CarModels:
             [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
        case Manufacturer:
             [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
        case CarModelYear:
             [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
        case Power:
             [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
        case Colors:
             [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
        case AccountType:
             [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
        case DOB:
             [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
        case Expiry:
             [self showValidateResult:![self isEmpty]];
            return ![self isEmpty];
            break;
        case Transit:
             [self showValidateResult:[self validTransit]];
            return [self validTransit];
            break;
        case Institution:
            [self showValidateResult:[self validInstitution]];
            return [self validInstitution];
            break;
        case AccountNumber:
            [self showValidateResult:[self validAccountNumber]];
            return [self validAccountNumber];
            break;
        default:
            break;
    }
    
    return NO;
}
#pragma mark PickerView
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
     label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    [label sizeToFit];
    BOOL isFirstRow = row == 0;
    if (self.mode == AppState) {
        if (isFirstRow) {
            label.text = self.states[row];
        }else{
            State *state =  self.states[row];
            label.text = state.name;
        }
    }else if (self.mode == AppCity){
        if (isFirstRow) {
            label.text = SHAREMANAGER.cities[row];
        }else{
        City *city =  SHAREMANAGER.cities[row];
        label.text = city.name;
        }
    }else if (self.mode == KCurrency) {
        if (isFirstRow) {
            label.text = self.currencies[row];
        }else{
            Currency *state =  self.currencies[row];
            label.text = [NSString stringWithFormat:@"%@ - %@",state.name,state.title];
        }
    }else if (self.mode == CarType){
        if (isFirstRow) {
            label.text =  self.vehicleTypes[row];
        }else{
        Vehicle *car =  self.vehicleTypes[row];
        label.text = car.name;
        }
    }else if (self.mode == Manufacturer){
        //DLog(@"manufacturers %@",[VehicleManager share].manufacturers);
        if (isFirstRow) {
            label.text =  [VehicleManager share].manufacturers[row];
        }else{
        Model *model =  [VehicleManager share].manufacturers[row];
        label.text = model.name;
        }
    }else if (self.mode == CarModels){
        if (isFirstRow) {
            label.text =  [VehicleManager share].models[row];
        }else{
        Model *model =  [VehicleManager share].models[row];
            label.text = model.name;
            
        }
    }else if (self.mode == CarModelYear){
        label.text = [VehicleManager share].modelYears[row];
    }else if (self.mode == Power){
        if (isFirstRow) {
            label.text =  [VehicleManager share].enginePower[row];
        }else{
        EnginePower *enginePower = [VehicleManager share].enginePower[row];
        label.text = enginePower.power;
        }
    }else if (self.mode == Colors){
        if (isFirstRow) {
            label.text =  [VehicleManager share].colors[row];
        }else{
        CarColor *carColor = [VehicleManager share].colors[row];
        label.text = carColor.name;
        }
    }else if (self.mode == AccountType){
        label.text = ACCOUNT_TYPES[row];
    }
    
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont normal]];
    return label;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self numberOfRowsInComponent];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        return;
    }
    if (self.mode == AppState) {
        State *state =  self.states[row];
        SHAREMANAGER.cities = state.cities;
        if (![SHAREMANAGER.cities containsObject:PLEASE_SELECT]) {
           [SHAREMANAGER.cities insertObject:PLEASE_SELECT atIndex:0];
        }
        self.text = state.name;
        self.tag = [state.stateId intValue];
        self.isVaild = YES;
    }else if (self.mode == AppCity){
        City *city =  SHAREMANAGER.cities[row];
        self.text = city.name;
        self.tag = [city.cityId intValue];
        self.isVaild = YES;
        
    }else if (self.mode == AccountType){
        self.text = ACCOUNT_TYPES[row];
        self.isVaild = YES;
        
    }else if (self.mode == KCurrency) {
        Currency *currency =  self.currencies[row];
        self.text = currency.name;
        self.tag = [currency.currencyId intValue];
        self.isVaild = YES;
        self.selectedCurrency = currency.name;
        [self addCountryCodeLabel];
    }else if (self.mode == CarType){
        Vehicle *car =  self.vehicleTypes[row];
        [VehicleManager share].olderYear    = car.olderYear;
        [VehicleManager share].colors       = car.colors;
        self.text = car.name;
        self.tag = [car.vId intValue];
        self.isVaild = YES;
        
    }else if (self.mode == Manufacturer){
        Company *company =  [VehicleManager share].manufacturers[row];
        [VehicleManager share].models = company.modeles;
        self.text = company.name;
        self.tag = [company.companyID intValue];
        self.isVaild = YES;
        
    }else if (self.mode == CarModels){
        Model *model =  [VehicleManager share].models[row];
        [VehicleManager share].enginePower = model.enginePowers;
         [VehicleManager share].colors = model.colors;
        self.text = model.name;
        self.tag = [model.modelID intValue];
        self.isVaild = YES;
    }else if (self.mode == CarModelYear){
        self.text = [VehicleManager share].modelYears[row];
        self.isVaild = YES;
        
    }else if (self.mode == Power){
        EnginePower *enginePower = [VehicleManager share].enginePower[row];
        self.text = enginePower.power;
        self.isVaild = YES;
        
    }else if (self.mode == Colors){
        CarColor *carColor = [VehicleManager share].colors[row];
        self.text = carColor.name;
        self.isVaild = YES;
        
    }
}
- (NSInteger)numberOfRowsInComponent{
        if (self.mode == AppState) {
          return  self.states.count;
        }else if (self.mode == AppCity){
            return  SHAREMANAGER.cities.count;
        }else if (self.mode == CarType){
            return  self.vehicleTypes.count;
        }else if (self.mode == Manufacturer){
            return [VehicleManager share].manufacturers.count;
        }else if (self.mode == CarModels){
            return [VehicleManager share].models.count;
        }else if (self.mode == Power){
            return [VehicleManager share].enginePower.count;
        }else if (self.mode == CarModelYear){
            return   [VehicleManager share].modelYears.count;
        }else if (self.mode == Colors){
            return  [VehicleManager share].colors.count;
        }else if (self.mode == AccountType){
            return  ACCOUNT_TYPES.count;
        }else if (self.mode == KCurrency){
            return  self.currencies.count;
        }
    return 0;
}

-(void)showValidateResult:(BOOL)isVaild{
    self.isVaild = isVaild;
//    if ([self.text isEqualToString:@""]) {
//        return;
//    }else
        if (self.mode == Phone  && [self.text isEqualToString:SHAREMANAGER.appData.country.countryCode]) {
        return;
    }
    !isVaild ? [self showError] : nil;
//    UIImage *image = isVaild ? RIGHT_IMAGE : WRONG_IMAGE;
//    [self addimageToTextfield:image];
    
    
    
}
- (BOOL)validCNIC{
    if(self.isEmpty){return false;}
    return self.text.length == CNIC_NUMBER_LENGHT;
}
- (BOOL)validRouting{
    if(self.isEmpty){return false;}
    return self.text.length == ROUTING_NUMBER_LENGHT;
}
- (BOOL)validPhone:(NSString*)number{
    return number.length != 0;
}
- (BOOL)validTransit{
    if(strEmpty(self.text)){ return false;}
    return self.text.length >= KTransitNumberLenght;
}
- (BOOL)validInstitution{
    if(strEmpty(self.text)){ return false;}
    return self.text.length == KInstitutionNumberLenght;
}
- (BOOL)validAccountNumber{
    if (!self.isAllowValidate) {
        return  true;
    }
    if(strEmpty(self.text)){ return false;}
    return self.text.length <= KAccountNumberLenght;
}
- (BOOL)validPassword:(NSString*)pssword{
    if(strEmpty(pssword))
        {
        return false;
        }
    
    return pssword.length >= MIX_PASSWORD_LENGHT;
}
- (BOOL)validEmail:(NSString*)emailStr{
    if(strEmpty(emailStr))
        {
        return false;
        }
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    if(![emailTest evaluateWithObject:emailStr])
        {
        return false;
        }
    return TRUE;
}
- (NSString *)dateFormate{
    if (self.mode == DOB || self.mode == Expiry) {
        return DATE_ONLY;
    }
    return  _datePicker.datePickerMode == UIDatePickerModeTime ? TIME_ONLY : DATE_ONLY;
}
- (UIToolbar *)toolbar{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setTintColor:[UIColor whiteColor]];
    //[toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked)];
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
   // [toolbar setTintColor:[UIColor appMonteCarloColor]];
    return  toolbar;
}
- (void)addEyeButton{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0,0, 30,self.frame.size.height);
    [addButton setImage:[UIImage imageNamed:@"ic_hide_password"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"ic_show_password"] forState:UIControlStateSelected];
    [addButton addTarget:self action:@selector(eyeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = addButton;
}
- (void)eyeButtonPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.secureTextEntry = !sender.selected;
}
-(void)addCountryCodeLabel{
    self.leftView = nil;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 30,ViewHeight(self))];
    UIImageView *flageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 25,ViewHeight(self))];
    UIImage *flageimage  =  [self flageImage:self.selectedCurrency];
    flageImageView.image = [flageimage fitInSize:CGSizeMake(25, 25)];
    flageImageView.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ViewWidth(flageImageView) + 3, 0, (ViewWidth(view) - ViewWidth(flageImageView)),ViewHeight(view))];
    label.tag = 121;
    label.font = self.font;
    label.textAlignment = NSTextAlignmentLeft;
    [label setTextColor:self.textColor];
    [label setText:nil];
    [view addSubview:flageImageView];
    [view addSubview:label];
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
}
- (UIImage *)flageImage:(NSString *)countryCode{
    countryCode = [countryCode substringToIndex:[countryCode length] - 1];
    NSString *imagePath = [NSString stringWithFormat:@"EMCCountryPickerController.bundle/%@", countryCode];
    UIImage *image = [UIImage imageNamed:imagePath inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    return  image;
}
-(void)addDropdownIconToRightView{
    if (!self.isDropDown) {
        return;
    }
    UIImage *image = DROPDOWN_ICON;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 30,self.frame.size.height)];
    UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 15, 15)];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView.center = view.center;
    [rightImageView setTintColor:[UIColor grayColor]];
    rightImageView.image = image;
    [view addSubview:rightImageView];
    self.rightView = view;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    
    
}

- (void)doneClicked{
    [self resignFirstResponder];
}

@end
