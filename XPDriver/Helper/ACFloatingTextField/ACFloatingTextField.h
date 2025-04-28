//
//  AppTextField.h
//  TFDemoApp
//
//  Created by Abhishek Chandani on 19/05/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KTransitNumberLenght 5
#define KInstitutionNumberLenght 3
#define KAccountNumberLenght 12
IB_DESIGNABLE

@interface ACFloatingTextField : UITextField
{
    UIView *bottomLineView;
    UIImageView *rightImageView;
    BOOL showingError;
}
typedef enum {
    Name=0,Email,Password,Phone,AppState,AppCity,CNIC,License,CarType,Manufacturer,CarModels,Power,CarModelYear,Colors,AccountType,Routing,DOB,Expiry,Transit,Institution,AccountNumber,Address,KCurrency
    
}validationMode;
@property (nonatomic, assign) BOOL isToday;

@property (nonatomic, assign) BOOL isAllowValidate;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSString *dateFormate;
@property (strong, nonatomic) NSString *selectedCurrency;
@property (nonatomic,strong) NSMutableArray *currencies;
@property (nonatomic,assign) BOOL isVaild;
/*
 * Add Drop icon to rightview;
 */
@property (nonatomic,assign) IBInspectable BOOL isDropDown;
// added by zia
@property (nonatomic,assign) IBInspectable int mode ;

@property (nonatomic, assign) IBInspectable BOOL isShowCountryCode;
/*
 * Change the Bottom line color. Default is Black Color.
 */
@property (nonatomic,strong) IBInspectable UIColor *lineColor;
/*
 * Change the Placeholder text color. Default is Light Gray Color.
 */
@property (nonatomic,strong) IBInspectable UIColor *placeHolderColor;
/*
 * Change the Placeholder text color when selected. Default is [UIColor colorWithRed:19/256.0 green:141/256.0 blue:117/256.0 alpha:1.0].
 */
@property (nonatomic,strong) IBInspectable UIColor *selectedPlaceHolderColor;
/*
 * Change the bottom line color when selected. Default is [UIColor colorWithRed:19/256.0 green:141/256.0 blue:117/256.0 alpha:1.0].
 */
@property (nonatomic,strong) IBInspectable UIColor *selectedLineColor;
/*
 * Change the error label text color. Default is Red Color.
 */
@property (nonatomic,strong) IBInspectable UIColor *errorTextColor;
/*
 * Change the error line color. Default is Red Color.
 */
@property (nonatomic,strong) IBInspectable UIColor *errorLineColor;
/*
 * Change the error display text.
 */
@property (nonatomic,strong) IBInspectable  NSString  *errorText;
/*
 * Shake line when showing error?.
 */
@property (assign) IBInspectable  BOOL disableShakeWithError;


@property (nonatomic,strong) UILabel *labelPlaceholder;
@property (nonatomic,strong) UILabel *labelErrorPlaceholder;


@property (assign) IBInspectable  BOOL disableFloatingLabel;

-(instancetype)init;
-(instancetype)initWithFrame:(CGRect)frame;

-(void)showError;
-(void)hideError;
-(void)showErrorWithText:(NSString *)errorText;
-(void)updateTextField:(CGRect)frame;



@end
