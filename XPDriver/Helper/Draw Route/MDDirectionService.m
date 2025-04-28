//
//  MDDirectionService.m
//  MapsDirections
//
//  Created by Mano Marks on 4/8/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "MDDirectionService.h"

@implementation MDDirectionService{
  @private
  BOOL _sensor;
  BOOL _alternatives;
  NSURL *_directionsURL;
  NSArray *_waypoints;
}

static NSString *kMDDirectionsURL = @"https://maps.googleapis.com/maps/api/directions/json?";

- (void)setDirectionsQuery:(NSDictionary *)query withSelector:(SEL)selector
              withDelegate:(id)delegate{
  NSArray *waypoints = [query objectForKey:@"waypoints"];
  NSString *origin = [waypoints objectAtIndex:0];
  int waypointCount = (int)[waypoints count];
  int destinationPos = waypointCount -1;
  NSString *destination = [waypoints objectAtIndex:destinationPos];
  NSString *sensor = [query objectForKey:@"sensor"];
  NSMutableString *url =
  [NSMutableString stringWithFormat:@"%@&origin=%@&destination=%@&sensor=%@",
   kMDDirectionsURL,origin,destination, sensor];
  if(waypointCount>2) {
    [url appendString:@"&waypoints=optimize:true"];
    int wpCount = waypointCount-2;
    for(int i=1;i<wpCount;i++){
      [url appendString: @"|"];
      [url appendString:[waypoints objectAtIndex:i]];
    }
  }
    [url appendString:[NSString stringWithFormat:@"&key=%@",GOOGLE_PLEACE_KEY]];
    url = [NSMutableString stringWithString: [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];

    _directionsURL = [NSURL URLWithString:url];
  [self retrieveDirections:selector withDelegate:delegate];
}
- (void)retrieveDirections:(SEL)selector withDelegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data =
        [NSData dataWithContentsOfURL:_directionsURL];
      [self fetchedData:data withSelector:selector withDelegate:delegate];
    });
}

- (void)fetchedData:(NSData *)data
       withSelector:(SEL)jsonSelector
       withDelegate:(id)delegate{
    
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    [delegate performSelector:jsonSelector withObject:json afterDelay:0];
}


@end
