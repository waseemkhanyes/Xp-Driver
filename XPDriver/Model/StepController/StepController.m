//
//  stepController.m
//  XPDriver
//
//  Created by Syed zia on 26/01/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//
#define METERS_TO_FEET  3.2808399
#define METERS_TO_MILES 0.000621371192
#define METERS_CUTOFF   1000
#define FEET_CUTOFF     3281
#define FEET_IN_MILES   5280


#import "StepController.h"

@implementation StepController
- (instancetype)initWithAttrebute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setAllSteps:[self getAllsteps:attribute[@"steps"]]];
    return self;
}
- (NSMutableArray *)getAllsteps:(NSMutableArray *)stepsArray{
    NSMutableArray *allSteps = [NSMutableArray new];
    for (NSDictionary *dic in stepsArray) {
        RouteStep *routeStep = [[RouteStep alloc] initWithAttributes:dic];
        [allSteps addObject:routeStep];
    }
    return allSteps;
}
- (void)removeCoordinate:(CLLocationCoordinate2D )coordinate{
    NSMutableArray *ar1 = [CommonFunctions roundedCoordinate:coordinate];
    for (RouteStep *step in self.allSteps) {
        NSMutableArray *ar2 = [CommonFunctions roundedCoordinate:step.coordinate];
        DLog(@"ar1: %@ ar2 %@",ar1,ar2);
        if ([ar1 isEqualToArray:ar2]) {
            DLog(@"step removed");
            [self.allSteps removeObjectAtIndex:[self.allSteps indexOfObject:step]];
            break;
        }
    }
}
- (NSString *)distance{
    int totalDistance = 0;
    for (RouteStep *step in self.allSteps) {
        totalDistance += step.distance;
    }
    DLog(@"Distance:%@",[self stringWithDistance:totalDistance]);
    return [self stringWithDistance:totalDistance];
}
- (NSString *)duration{
    int totalDuration = 0;
    for (RouteStep *step in self.allSteps) {
        totalDuration += step.duration;
    }
    double durationInMinutes = totalDuration / 60;
     DLog(@"Duration:%@",strFormat(@"%@",@(roundf(durationInMinutes))));
    return strFormat(@"%@ mins",@(roundf(durationInMinutes + .05)));
}


- (NSString *)stringWithDistance:(int)distance {
    BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
    
    NSString *format;
    
    if (isMetric) {
        if (distance < METERS_CUTOFF) {
            format = @"%@ metres";
        } else {
            format = @"%@ km";
            distance = distance / 1000;
        }
    } else { // assume Imperial / U.S.
        distance = distance * METERS_TO_FEET;
        if (distance < FEET_CUTOFF) {
            format = @"%@ feet";
        } else {
            format = @"%@ miles";
            distance = distance / FEET_IN_MILES;
        }
    }
    
    return [NSString stringWithFormat:format, [self stringWithDouble:distance]];
}

// Return a string of the number to one decimal place and with commas & periods based on the locale.
- (NSString *)stringWithDouble:(double)value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
}




@end
