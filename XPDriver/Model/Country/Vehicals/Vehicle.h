//
//  Vehicles.h
//  Nexi
//
//  Created by Syed zia on 20/07/2016.
//  strongright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Company.h"
#import "CarColor.h"
#import "EnginePower.h"
#import "Model.h"

@interface Vehicle : NSObject
@property (nonatomic,strong) NSString *vId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) UIImage  *image;
@property (nonatomic,strong) UIImage *selectedImage;
@property (nonatomic,assign) NSInteger  olderYear;
@property (nonatomic,strong) NSMutableArray *companies;
@property (nonatomic,strong) NSMutableArray *colors;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;

@end
