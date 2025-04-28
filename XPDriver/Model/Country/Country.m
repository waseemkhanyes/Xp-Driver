//
//  Country.m
//  Nexi
//
//  Created by Asrar ul Hasan on 15/07/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//
#import "City.h"
#import "State.h"
#import "Document.h"

#import "Country.h"

@implementation Country

- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSDictionary *countryDic   = [attribute objectForKey:COUNTRY];
    NSDictionary *carTypes     = attribute[@"CarTypes"];
    NSArray *colors     = attribute[COLOR];
    NSArray *documentsDic     = attribute[DOCUMENTS];
    NSString *cid = [countryDic objectForKey:@"country_id"];
    NSString *name = [countryDic objectForKey:@"name"];
    NSString *shortName = [countryDic objectForKey:@"iso_code_2"];
    NSString *image = [countryDic objectForKey:@"img"];
    NSString *currencey = [countryDic objectForKey:@"currencey"];
    NSString *countryCode = [countryDic objectForKey:@"country_code"];
    [self setCountryId:cid];
    [self setName:name];
    [self setShortName:shortName];
    [self setImage:image];
    [self setCurrencey:currencey];
    [self setCountryCode:countryCode];
    [self setPhoneFormate:countryDic[@"ph_formate"]];
    if (countryDic[@"ph_length"]) {
        [self setPhoneLenght:[countryDic[@"ph_length"] intValue] ];//+ (int)self.countryCode.length];
    }else{
         [self setPhoneLenght:10 + (int)self.countryCode.length];
    }
    [self setStates:[self stateies:countryDic[STATES]]];
    [self setVehicles:[self vehicles:@{VEHICLES:carTypes[VEHICLES],COLOR:colors}]];
    [self setDocuments:[self documents: documentsDic]];
    
    return self;
}
- (NSMutableArray *)stateies:(NSArray *)stateAttribute{
    NSMutableArray *stateis = [NSMutableArray new];
    for (NSDictionary *dic in stateAttribute) {
        State *state = [[State alloc] initWithAttribute:dic];
        state.cities = [self cities:dic[CITYIES]];
        [stateis addObject:state];
    }
    return stateis;
}
- (NSString *)statIdByName:(NSString *)name{
    for (State *state in self.states) {
        if ([state isKindOfClass:[State class]] && [state.name isEqualToString:name]) {
            return state.stateId;
            break;
        }
    }
    return @"";
}
- (NSMutableArray *)cities:(NSArray *)cityArray{
    NSMutableArray *cities = [NSMutableArray new];
    for (NSDictionary *dic in cityArray) {
        City *city = [[City alloc] initWithAttribute:dic];
        [cities addObject:city];
    }
    return cities;
}
- (NSMutableArray *)documents:(NSArray *)documentsArray{
    NSMutableArray *documents = [NSMutableArray new];
    for (NSDictionary *dic in documentsArray) {
        Document *doc = [[Document alloc] initWithAttribute:dic];
        [documents addObject:doc];
    }
    return documents;
}

- (NSMutableArray *)vehicles:(NSDictionary *)vehiclesDicationary{
    NSMutableArray *vehiclas = [NSMutableArray new];
    NSArray        * vehiclesArray = vehiclesDicationary[VEHICLES];
    NSArray      *colorArray       = vehiclesDicationary[COLOR];
    for (NSDictionary *dic in vehiclesArray) {
        NSDictionary *vdic = @{VEHICLES:dic,COLOR:colorArray};
        Vehicle *vehical = [[Vehicle alloc] initWithAttribute:vdic];
        [vehiclas addObject:vehical];
    }
    return vehiclas;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.countryId forKey:@"countryId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.currencey forKey:@"currencey"];
    [encoder encodeObject:self.countryCode forKey:@"countryCode"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        self.countryId    = [decoder decodeObjectForKey:@"countryId"];
        self.name         = [decoder decodeObjectForKey:@"name"];
        self.image        = [decoder decodeObjectForKey:@"image"];
        self.currencey    = [decoder decodeObjectForKey:@"currencey"];
        self.countryCode    = [decoder decodeObjectForKey:@"countryCode"];
        
    }
    return self;
}

@end
