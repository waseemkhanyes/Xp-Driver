//
//  SZTextField.h
//  XPEats
//
//  Created by Macbook on 29/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Utilties.h"


NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
typedef enum {
    Card=0,Date,CVC
    
}SZTextFieldMode;

@interface SZTextField : UITextField
@property (nonatomic,assign) IBInspectable int mode ;
@property (nonatomic,assign) IBInspectable BOOL isLeftPading;
@property (nonatomic,assign) IBInspectable float cornnerRadius;

@end

NS_ASSUME_NONNULL_END
