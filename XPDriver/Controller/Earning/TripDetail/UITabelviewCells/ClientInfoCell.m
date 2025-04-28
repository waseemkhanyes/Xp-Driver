//
//  DriverInfoCell.m
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "ClientInfoCell.h"
#import "XP_Driver-Swift.h"

@implementation ClientInfoCell

- (void)awakeFromNib {
    self.layer.shadowOffset = CGSizeMake(1, 0);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = .25;
    CGRect shadowFrame = self.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
    self.layer.shadowPath = shadowPath;
    [super awakeFromNib];
    
    
    // Initialization code
}
- (void)configerName:(NSString *)name  picURL:(NSURL *)picURL carType:(NSString *)carType carinfo:(NSString *)carinfo{
    [self.nameLabel setText:name];
    [self.vehicleTypeLabel setText:carType];
    [self.vehicleInfoLabel setText:carinfo];
    [self.clientImageView round];
    [self getClientImage:picURL];
    
}
//-(void)getClientImage:(NSURL *)picURL{
//
//    __weak typeof(self) weakSelf = self;
//    if (picURL) {
//        [weakSelf.clientImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:picURL]
//                                        placeholderImage:USER_PLACEHOLDER
//                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//                                                     weakSelf.clientImageView.image  = image;
//                                                     
//                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){ }];
//    }
//    
//}

-(void)getClientImage:(NSURL *)picURL{
    __weak typeof(self) weakSelf = self;
    if (picURL) {
        NSString *urlString = [picURL absoluteString];
        [AlamofireWrapper downloadImageFrom:urlString completion:^(UIImage *downloadedImage) {
            // Handle downloadedImage or nil as needed
            if (downloadedImage) {
                // Do something with the downloaded image
                self.clientImageView.image  = downloadedImage;
                
            } else {
                // Handle the case when the image download fails
            }
        }];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
