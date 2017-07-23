//
//  HistoryItem.h
//  CabsPoint
//
//  Created by Brian on 2/6/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryItem : NSObject
{
}

@property (nonatomic) int ID;
@property (nonatomic) NSString* pickupAddress;
@property (nonatomic) NSString* dropAddress;
@property (nonatomic) NSString* companyName;
@property (nonatomic) double priceQuote;
@property (nonatomic) NSString* pickupTime;
@property (nonatomic) BOOL cancellable;


@end
