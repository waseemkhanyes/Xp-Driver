//
//  Vehicles.m
//  Nexi
//
//  Created by Syed zia on 20/07/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "Vehicle.h"


@implementation Vehicle
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self =[super init];
    if (!self) {
        return nil;
    }
    NSDictionary *typesDic = attribute[VEHICLES];
  

    UIImage *image = imagify(typesDic[@"car_img"]);
    NSArray *colorsArray = attribute[COLOR];
    UIImage *selectedImage = imagify(typesDic[@"car_img_sel"]);
    UIColor *imageColor = [UIColor colorFromHexString:typesDic[@"unselected_color"]];
    UIColor *selectedImageColor  =  [UIColor colorFromHexString:typesDic[@"selected_color"]];
    [self setOlderYear:[typesDic[@"older_year"] integerValue]];
    [self  setVId:strFormat(@"%@",typesDic[@"id"])];
    [self  setName:typesDic[@"car_name"]];
    [self  setImage:image];
    [self setColors:[self color:colorsArray]];
    [self setSelectedImage:selectedImage];
    if (imageColor) {
         [self setImage:[image initWithColor:imageColor]];
    }if (selectedImageColor) {
         [self setSelectedImage:[selectedImage initWithColor:selectedImageColor]];
    }
   
    
    return self;
}
- (NSMutableArray *)companies:(NSDictionary *)companiewArray{
    NSMutableArray *allModels = [NSMutableArray new];
    
    NSArray *companiesDictionary   = companiewArray[COMPANIES];
    NSArray      *powerArray       = companiewArray[ENGINE_POWER];
    NSArray      *colorArray       = companiewArray[COLOR];
    NSDictionary *modelsDictionary = companiewArray[MODELS];
    for (NSDictionary *dic in companiesDictionary) {
        Company *company = [[Company alloc] initWithAttribute:dic];
        NSArray *modelArray = [NSArray new];
        if (modelsDictionary[company.name]) {
            modelArray = modelsDictionary[company.name];
        }
        NSDictionary *modelDictionary = @{MODELS:modelArray,ENGINE_POWER:powerArray,COLOR:colorArray};
        company.modeles = [self models:modelDictionary];
        [allModels addObject:company];
    }
    return allModels;
}
- (NSMutableArray *)models:(NSDictionary *)modelsdictionary{
    NSArray  *powerArray       = modelsdictionary[ENGINE_POWER];
    NSArray  *colorArray       = modelsdictionary[COLOR];
    NSArray  *modelsArray      = modelsdictionary[MODELS];
    NSMutableArray *allModels = [NSMutableArray new];
    for (NSDictionary *dic in modelsArray) {
        if (dic.count != 0) {
            Model *model = [[Model alloc] initWithAttribute:dic];
            model.enginePowers = [self enginePower:powerArray];
            model.colors       = [self color:colorArray];
            [allModels addObject:model];
        }
        
    }
    return allModels;
}
- (NSMutableArray *)enginePower:(NSArray *)powerArray{
    NSMutableArray *powerAry = [NSMutableArray new];
    for (NSDictionary *dic in powerArray){
        [powerAry addObject:[[EnginePower alloc] initWithAttribute:dic]];
    }
return powerAry;
}
- (NSMutableArray *)color:(NSArray *)colorArray{
    NSMutableArray *colorAry = [NSMutableArray new];
    for (NSDictionary *dic in colorArray){
        [colorAry addObject:[[CarColor alloc] initWithAttribute:dic]];
    }
    return colorAry;
}
+(id)setVehicelId:(NSString *)vId name:(NSString *)name image:(UIImage *)img selectedimage:(UIImage *)selImg{
    
    Vehicle *v  = [Vehicle new];
    [v  setVId:vId];
    [v  setName:name];
    [v  setImage:[img initWithColor:[UIColor appGrayColor]]];
    [v setSelectedImage:[img initWithColor:[UIColor appBlueColor]]];
    return v;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.vId forKey:@"vId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.selectedImage forKey:@"selectedImage"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        self.vId       = [decoder decodeObjectForKey:@"vId"];
        self.name      = [decoder decodeObjectForKey:@"name"];
        self.image     = [decoder decodeObjectForKey:@"image"];
        self.selectedImage     = [decoder decodeObjectForKey:@"selectedImage"];
    }
    return self;
}

@end
