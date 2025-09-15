//
//  Order.m
//  XPDriver
//
//  Created by Macbook on 30/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//
#import "DetailOption.h"
#import "Order.h"
#import "XP_Driver-Swift.h"
@implementation Order
- (instancetype)initWithAtrribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSDictionary *orderDetailDic = attribute[@"orderDetail"];
    NSDictionary *orderTrackingDic = orderDetailDic[@"order_tracking"];
    NSDate *date = [NSDate dateFromString:orderDetailDic[@"date_ordered"] withFormat:DATE_AND_TIME_S];
    [self setDropLocation:[[MyLocation alloc] initWithAddress:orderTrackingDic[@"drop_address"] coordinateString:orderTrackingDic[@"drop_coordinate"] distance:0]];
    [self setPaymentMethod:[orderDetailDic[@"payment_method"] stringValue]];
    [self setSubTotal:[orderDetailDic[@"sub_total"] stringValue]];
    //    [self setOrderTime:attribute[@"created_at"]];
    //     [self setPreparingtime:orderDetailDic[@"ave_time"]];
    //    [self setProcessingMinutes:[orderDetailDic[@"processing_minutes"] intValue]];
    //    [self setDeliveryMinutes:[orderDetailDic[@"delivery_minutes"] intValue]];
    [self setNote:orderDetailDic[@"buyer_note"]];
    [self setAddressNote:orderTrackingDic[@"address_note"]];
    [self setOrderId:attribute[@"orderId"]];
    //    [self setPrice:attribute[@"price"]];
    [self setStatus:[attribute[@"status"] intValue]];
    [self setDateOrdered:[date stringWithFormat:DATE_TIME_DISPLAY]];
    [self setTip:[orderDetailDic[@"tip_amount"] floatValue]];
    //    [self setServiceFee:[orderDetailDic[@"service_fee"] floatValue]];
    //    [self setDeliveryFee:[orderDetailDic[@"delivery_charge"] floatValue]];
    //    [self setTax:[orderDetailDic[@"tax"] floatValue]];
    [self setCurrrencySymbol:orderDetailDic[@"currrency_symbol"]];
    [self setCurrrencyCode:orderDetailDic[@"currency_code"]];
    [self setIsDelivery:[orderDetailDic[@"picked_or_deliverd"] boolValue]];
    [self setTotalprice:[orderDetailDic[@"total_amount"] floatValue]];
    [self setTotalAmount:[NSString currencyString:self.totalprice currency:self.currrencySymbol]];
    [self setStatusName:orderDetailDic[@"status_name"]];
    [self setPickedUpTime:[attribute[@"pickedTime"] dateString]];
    [self setDeliveredTime:[attribute[@"delivedTIme"] dateString]];
    [self setBrandLogoUrl:[NSURL URLWithString:orderDetailDic[@"image_1"]]];
    [self setRestaurant:[[OrderRestaurant alloc]initWithAtrribute:orderDetailDic[@"resturant"]]];
    //    [self setOrderTracking:[[OrderTracking alloc]initWithAtrribute:orderTrackingDic]];
    [self setIsActive: [attribute[@"active"] boolValue]];
    [self setDistance:attribute[@"distance"]];
    [self setIsRequested:self.status == KOrderStatusAssigned];
    [self setIsAccepted:self.status == KOrderStatusAccepted];
    [self setIsArrived:self.status == KOrderStatusReached];
    [self setIsPickedUp:self.status == KOrderStatusPickedup];
    [self setIsDelivered:self.status == KOrderStatusDelivered];
    [self setIsRejected:self.status == KOrderStatusRejected];
    [self setIsMissed:self.status == KOrderStatusSkiped];
//    int additation = !self.isPickedUp? 10 : 0;
    //    [self setPreparingtime:[NSString stringWithFormat:@"%@",@(self.deliveryMinutes + additation).stringValue]];
    if ([orderDetailDic[@"user"] isKindOfClass:[NSDictionary class]]) {
        [self setCustomer:[[Customer alloc] initWithAttrebute:orderDetailDic[@"user"]]];
    }
    NSArray *items = orderDetailDic[@"items"];
//    NSMutableArray *allInvoiceItems = [self getAllInvoiceItems:items currrencySymbol:self.currrencySymbol];
    NSMutableArray *allPriceItems = [self getPriceItems:orderDetailDic[@"driver_price"] currrencySymbol:self.currrencySymbol];
    //    [self setInvoiceItems:[NSMutableArray arrayWithArray:[allInvoiceItems arrayByAddingObjectsFromArray:[allPriceItems mutableCopy]]]];
    [self setPriceInvoiceItems:allPriceItems];
    //    [self setOrderInfo:[self orderInfo:items]];
    [self setItems:[self allOrderItems:items]];
    [self setDriverFee:[self driverFee]];
    [self setDriverFeeWithoutCurrent:[self driverFeeWithoutCurrent]];
    
    [self setDetailOptions:[self getDetailOptions:orderDetailDic[@"detail_option"]]];
    [self setParkingStopNumber:[self getParkingStopNumber]];
    [self setVehicleInfo:[self getVehicleInfo]];
    [self setIsEventOrder:self.detailOptions.count != 0];
    [self setAptNumber:orderTrackingDic[@"apartment_number"]];
    
    [self setBuyerNote:orderDetailDic[@"buyer_note"]];
    [self setDropAddress:orderTrackingDic[@"drop_address"]];
    
    [self setFullPrice:[NSString stringWithFormat:@"%@%@ %@", orderDetailDic[@"currrency_symbol"], orderDetailDic[@"total_amount"], orderDetailDic[@"currency_code"]]];
    [self setFullPriceWithoutCode:[NSString stringWithFormat:@"%@%@", orderDetailDic[@"currrency_symbol"], orderDetailDic[@"total_amount"]]];
    [self setDeliveryDate:orderDetailDic[@"delivery_date"]];
    [self setIsCouponApplied:[self getIsCouponValue:orderDetailDic[@"price"]]];
    return self;
}
- (BOOL)isEqual:(id)object{
    Order *otherOrder = (Order *)object;
    BOOL equal =  [self.orderId isEqualToString:otherOrder.orderId] && self.status == otherOrder.status;
    return equal;
}
- (NSMutableArray *)allOrderItems:(NSArray *)orderItems{
    NSMutableArray *items = [NSMutableArray new];
    for (NSDictionary *dic in orderItems) {
        [items addObject:[[OrderItem alloc]initWithAttribute:dic]];
    }
    
    return items;
}
- (NSString *)orderInfo:(NSArray *)items{
    NSString *info = nil;
    for (NSDictionary *dic in items) {
        info = !info ?  [NSString stringWithFormat:@"%@\n",dic[@"name"]] : [NSString stringWithFormat:@"%@\n%@\n",info,dic[@"name"]];
        NSArray *subItems = dic[@"subitem"];
        for (NSDictionary *dic in subItems) {
            info = [NSString stringWithFormat:@"%@ (%@) %@\n",info,dic[@"qty"],dic[@"name"]];
        }
    }
    return info;
}

- (NSMutableArray *)getPriceItems:(NSArray *)priceArray currrencySymbol:(NSString *)currrencySymbol{
    NSMutableArray *allInvoiceItems = [NSMutableArray new];
    for (NSDictionary *dic in priceArray) {
        InvoiceItem *newInvoiceItem = [[InvoiceItem alloc] initWithTitel:dic[@"meta_key"] price:dic[@"meta_value"] currrencySymbol:currrencySymbol];
        [allInvoiceItems addObject:newInvoiceItem];
        
    }
    return allInvoiceItems;
}

- (BOOL)getIsCouponValue:(NSArray *)priceArray {
    BOOL value = NO;
    for (NSDictionary *dic in priceArray) {
        if ([dic[@"meta_key"] isEqualToString:@"Coupon"]) {
            value = YES;
        }
    }
    return value;
}

- (NSString *)driverFee{
    for (InvoiceItem *invoiceItem in self.priceInvoiceItems) {
        if ( [invoiceItem.title isEqualToString:@"You Earn"]) {
            return invoiceItem.priceInfo;
        }
    }
    return @"";
}

- (NSString *)driverFeeWithoutCurrent {
    for (InvoiceItem *invoiceItem in self.priceInvoiceItems) {
        if ([invoiceItem.title isEqualToString:@"You Earn Only Amount"]) {
            return invoiceItem.priceInfo;
        }
    }
    return @"0.0";
}

//- (NSString *)fullPrice{
//    NSString *strPrice = [NSString stringWithFormat:@"%@", @""];
//    for (InvoiceItem *invoiceItem in self.priceInvoiceItems) {
//        if ( [invoiceItem.title isEqualToString:@"TOTAL"]) {
//            return invoiceItem.priceInfo;
//        }
//
//    }
//    return @"";
//}

//- (NSMutableArray *)getAllInvoiceItems:(NSArray *)items currrencySymbol:(NSString *)currrencySymbol{
//    NSMutableArray *allInvoiceItems = [NSMutableArray new];
//    for (NSDictionary *dic in items) {
//        InvoiceItem *newInvoiceItem = [[InvoiceItem alloc] initWithAttribute:dic currrencySymbol:currrencySymbol];
//        [allInvoiceItems addObject:newInvoiceItem];
//        NSArray *subItems = dic[@"subitem"];
//        for (NSDictionary *dic in subItems) {
//            InvoiceItem *newInvoiceItem = [[InvoiceItem alloc] initWithAttribute:dic currrencySymbol:currrencySymbol];
//            [allInvoiceItems addObject:newInvoiceItem];
//        }
//    }
//    return allInvoiceItems;
//}
- (NSMutableArray *)getDetailOptions:(NSArray *)priceArray{
    NSMutableArray *allDetailOptions = [NSMutableArray new];
    for (NSDictionary *dic in priceArray) {
        NSString *value = dic[@"meta_value"];
        if (!value.isEmpty) {
            DetailOption *detailOption = [[DetailOption alloc] initWithTitel:dic[@"meta_key"] subTitel:dic[@"meta_value"] ];
            [allDetailOptions addObject:detailOption];
        }
    }
    return allDetailOptions;
}
- (NSString *)getParkingStopNumber{
    return  [self getDtailOption:@"_spot_parking"];
}
- (NSString *)getVehicleInfo{
    return  [self getDtailOption:@"_vehicle_info"];
}
- (NSString *)getDtailOption:(NSString *)string{
    for (DetailOption *dop in self.detailOptions) {
        if ([dop.title isEqualToString:string]) {
            return dop.subtitel;
        }
    }
    return nil;
}
//- (void)cancelOrder:(NSDictionary *)paramater Completion:(void (^)(NSString *error))block{
//    [NetworkController apiGetWithParameters:paramater Completion:^(id JSON, NSString *error) {
//        if (!error) {
//            DLog(@"JSON %@",JSON[@"data"]);
//            BOOL success = [JSON[@"success"] boolValue];
//            if (success) {
//                 block(nil);
//            }else{
//                block(JSON[@"msg"]);
//            }
//
//        }else{
//            block(error);
//        }
//
//    }];
//    // block([self allPopularRestaurents],nil);
//}

- (void)cancelOrder:(NSDictionary *)paramater Completion:(void (^)(NSString *error))block{
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodGet
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:paramater
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response cancelOrder JSON: %@", json);
        DLog(@"JSON %@",json[@"data"]);
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            block(nil);
        }else{
            block(json[@"msg"]);
        }
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        block(error.localizedDescription);
    }];
    // block([self allPopularRestaurents],nil);
}

@end
