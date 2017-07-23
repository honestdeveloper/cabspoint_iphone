//
//  QuoteItem.m
//  CabsPoint
//
//  Created by Brian on 2/5/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "QuoteItem.h"

@implementation QuoteItem

-(id)init
{
    self = [super init];
    if(self)
    {
        self.ID = 0;
        self.companyName = @"";
        self.onTime = 0;
        self.priceQuote = 0;
        self.timeLimit = 0;
        self.companyStatus = -1;
        self.ratingBarPoint = 0;
        self.priceDetails = @"";
        self.startTime = 0;
        self.carType = 1;
        self.retTflag = 0;
    }
    return self;
}
@end
