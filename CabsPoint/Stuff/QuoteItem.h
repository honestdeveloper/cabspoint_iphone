//
//  QuoteItem.h
//  CabsPoint
//
//  Created by Brian on 2/5/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuoteItem : NSObject

@property (nonatomic) int ID;
@property (nonatomic) NSString* companyName;
@property (nonatomic) int onTime;
@property (nonatomic) double priceQuote;
@property (nonatomic) int timeLimit;
@property (nonatomic) int companyStatus;
@property (nonatomic) float ratingBarPoint;
@property (nonatomic) NSString* priceDetails;
@property (nonatomic) long startTime;
@property (nonatomic) int carType;
@property (nonatomic) int retTflag;
@end
