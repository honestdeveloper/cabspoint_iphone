//
//  PlaceJSONParser.m
//  CabsPoint
//
//  Created by Brian on 1/30/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "PlaceJSONParser.h"
#import "JSON.h"

@implementation PlaceJSONParser

+(NSArray*)parsePlaces:(NSString*)jsonString
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    @try {
        NSDictionary* root = [[jsonString JSONValue] objectForKey:@"info"];
        NSDictionary* locationNames = [root objectForKey:@"name"];
        NSDictionary* geoLocations = [root objectForKey:@"geolocation"];
        NSDictionary* distances;
        @try {
            distances = [root objectForKey:@"distance"];
        }
        @catch (NSException *exception) {
            
        }
        
        NSString* postCode;
        NSArray* geoLocation, *holdings;
        NSDictionary* townNames, *streetNames;
        NSString* town, *street, *locationName;
        NSMutableDictionary* place;
        double distance = 0;
        int numHoldings;
        for(id key in locationNames)
        {
            postCode = (NSString*)key;
            geoLocation = [geoLocations objectForKey:postCode];
            townNames = [locationNames objectForKey:postCode];
            @try {
                if(distances.count > 0 && [distances objectForKey:postCode] != nil)
                    distance = [[distances objectForKey:postCode] doubleValue];
            }
            @catch (NSException *exception) {
                distance = 0;
            }
            
            for(id townKey in townNames)
            {
                town = townKey;
                streetNames = [townNames objectForKey:town];
                locationName = @"";
                if(town.length > 0)
                {
                    locationName = [NSString stringWithFormat:@" %@", [town uppercaseString]];
                }
                for(id streetKey in streetNames)
                {
                    street = streetKey;
                    if(street.length > 0)
                    {
                        locationName = [NSString stringWithFormat:@" %@%@", street, locationName];
                    }
                    holdings = [streetNames objectForKey:street];
                    numHoldings = holdings.count;
                    
                    for(int i = 0; i < numHoldings; i++)
                    {
                        place = [[NSMutableDictionary alloc] init];
                        [place setValue:[NSString stringWithFormat:@"%@%@", holdings[i], locationName] forKey:@"locationName"];
                        [place setValue:geoLocation[0]  forKey:@"lat"];
                        [place setValue:geoLocation[1]  forKey:@"lng"];
                        [place setValue:postCode  forKey:@"postCode"];
                        [place setValue:[NSString stringWithFormat:@"%f", distance]  forKey:@"distance"];
                        [array addObject:place];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {

    }

    
    return array;
}

@end
