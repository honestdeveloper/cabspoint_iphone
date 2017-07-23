//
//  BookingInformation.h
//  CabsPoint
//
//  Created by Michael on 1/18/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookingInformation : NSObject
{
    int identification;
    NSString* pickupAddress1;
    NSString* pickupTown;
    NSString* pickupPostCode;
    int pickupAddressType;
    NSString* pickupEditAddress;
    NSString* pickupFlightNumber;
    NSDate* pickupDateTime;
    
    NSString* dropAddress1;
    NSString* dropTown;
    NSString* dropPostCode;
    int dropAddressType;
    NSString* dropEditAddress;
    
    NSString* viaAddress1;
    NSString* viaTown;
    NSString* viaPostCode;
    int viaAddressType;
    NSString* viaEditAddress;
    BOOL isASAP;
    int passengerCount;
    int suitcaseCount;
    BOOL hasChildSeat;
    BOOL hasWheelChair;
    BOOL isPetFriendly;
    NSString* comment;
}

@property (nonatomic) int identification;
@property (nonatomic) NSString* pickupAddress1;
@property (nonatomic) NSString* pickupTown;
@property (nonatomic) NSString* pickupPostCode;
@property (nonatomic) int pickupAddressType;
@property (nonatomic) NSString* pickupEditAddress;
@property (nonatomic) NSString* pickupFlightNumber;
@property (nonatomic) NSDate* pickupDateTime;

@property (nonatomic) NSString* dropAddress1;
@property (nonatomic) NSString* dropTown;
@property (nonatomic) NSString* dropPostCode;
@property (nonatomic) int dropAddressType;
@property (nonatomic) NSString* dropEditAddress;

@property (nonatomic) NSString* viaAddress1;
@property (nonatomic) NSString* viaTown;
@property (nonatomic) NSString* viaPostCode;
@property (nonatomic) int viaAddressType;
@property (nonatomic) NSString* viaEditAddress;
@property (nonatomic) BOOL isASAP;
@property (nonatomic) int passengerCount;
@property (nonatomic) int suitcaseCount;
@property (nonatomic) BOOL hasChildSeat;
@property (nonatomic) BOOL hasWheelChair;
@property (nonatomic) BOOL isPetFriendly;
@property (nonatomic) NSString* comment;

@end
