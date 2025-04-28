//
//  Country.h
//  Nexi
//
//  Created by Asrar ul Hasan on 15/07/2016.
//  strongright © 2016 Syed zia ur Rehman. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface Country : NSObject
@property (nonatomic,strong) NSString *countryId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *currencey;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *countryCode;
@property (nonatomic,strong) NSString *shortName;
@property (nonatomic,assign) NSString  *phoneFormate;
@property (nonatomic,assign)  int       phoneLenght;
@property (nonatomic,strong) NSMutableArray *states;
@property (nonatomic,strong) NSMutableArray *documents;
@property (nonatomic,strong) NSMutableArray *vehicles;
- (NSString *)statIdByName:(NSString *)name;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end
