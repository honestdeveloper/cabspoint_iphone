//
//  BookingInformation.m
//  CabsPoint
//
//  Created by Michael on 1/18/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "BookingInformation.h"

@implementation BookingInformation

-(id)init
{
    self = [super init];
    if(self)
    {
        self.identification = 0;
        self.pickupAddress1 = @"";
        self.pickupTown = @"";
        self.pickupPostCode = @"";
        self.pickupAddressType = 0;
        self.pickupEditAddress = @"";
        self.pickupFlightNumber = @"";
        self.pickupDateTime = [[NSDate alloc] init];
        self.dropAddress1 = @"";
        self.dropTown = @"";
        self.dropPostCode = @"";
        self.dropAddressType = 0;
        self.dropEditAddress = @"";
        self.viaAddress1 = @"";
        self.viaTown = @"";
        self.viaPostCode = @"";
        self.viaAddressType = 0;
        self.viaEditAddress = @"";
        self.isASAP = true;
        self.passengerCount = 1;
        self.suitcaseCount = 0;
        self.hasChildSeat = false;
        self.hasWheelChair = false;
        self.isPetFriendly = false;
        self.comment = @"";
    }
    return self;
}

@end
