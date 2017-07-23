//
//  PlaceJSONParser.h
//  CabsPoint
//
//  Created by Brian on 1/30/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceJSONParser : NSObject

+(NSArray*)parsePlaces:(NSString*)jsonString;
@end
