//
//  RoundedButton.h
//  XPDriver
//
//  Created by Syed zia on 30/07/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface RoundedButton : UIButton

typedef enum {
    Semple=0,Started = 1,Ended = 2,Disable=3,Unknown = -1
}buttonType;
@property (strong, nonatomic) NSString *currentText;
@property (assign) BOOL isSkipDeShape;
@property (readonly) BOOL isLoading;
@property float animationDuration;
@property BOOL disableWhileLoading;
- (void)showLoading;
- (void)hideLoading;
- (void)hideLoadingWithTitel:(NSString *)titel;
@property (nonatomic,assign) IBInspectable int type ;
@property (nonatomic,assign) IBInspectable int cornerRadius;
@property (nonatomic,assign) IBInspectable UIColor *borderColor;

@end
