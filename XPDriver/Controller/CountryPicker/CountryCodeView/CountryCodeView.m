//
//  CountryCodeView.m
//  XPFood
//
//  Created by syed zia on 02/08/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import "CountryCodeView.h"

@implementation CountryCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTapGesture];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self addTapGesture];
}
- (void)configerWithCountry:(EMCCountry *)country delegate:(id <CountryCodeViewDelegate>)delegate{
    self.delegate = delegate;
    [self updateUI:country];
}

- (void)updateUI:(EMCCountry *)country{
    NSString *countryCode = [country countryCode];
    self.codeLabel.text = [NSString stringWithFormat:@"%@", [country dialingCode]];
    NSString *imagePath = [NSString stringWithFormat:@"EMCCountryPickerController.bundle/%@", countryCode];
    UIImage *image = [UIImage imageNamed:imagePath inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    self.imageView.image = [image fitInSize:CGSizeMake(30, 30)];
}
- (void)addTapGesture{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.delegate showCountryPicker];
}

@end
