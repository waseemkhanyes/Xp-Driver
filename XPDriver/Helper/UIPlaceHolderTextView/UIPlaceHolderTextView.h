//
//  UIPlaceHolderTextView.h
//  fivestartdriver
//
//  Created by Syed zia ur Rehman on 25/08/2015.
//  Copyright (c) 2015 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
