//
//  ConfigInfo.h
//  CabsPoint
//
//  Created by Michael on 1/19/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
    SEARCH = 0,
    HOSPITAL,
    AIRPORT,
    TRAIN_STATION,
    STADIUM,
    FAVOURITE,
    NEAREST_LOCATION
};

#define AUTO_COMPLETE_THRESHOLD 5
#define NEAREST_LOCATION 6

#define BROWSER_API_KEY @"AIzaSyCp2PORXcUD7ko06Cq3w1QqNsDbHKFW9Y0"
#define COUNTRY_CODE @"UK"

#define CONFIG_INFO [ConfigInfo getInstance]

#define REGISTERED_KEY @"registered"
#define APP_ID_KEY @"app_id"
#define HOST_PROSMS_KEY @"host_prosms"
#define URL_KEY @"url"
#define NAME_KEY @"name"
#define PHONE_KEY @"phone"
#define EMAIL_KEY @"email"
#define ACCOUNT_NUMBER_KEY @"account_number"
#define ACCOUNT_BOOK_KEY @"account_book"
#define CASHCARD_BOOK_KEY @"cashcard_book"
#define HELPDESKNUMBER_KEY @"help_desk_number"
#define SKIP_PAYMENT_KEY @"skip_payment"
#define CASH_KEY @"cash"
#define PREV_SEARCHTEXT_KEY @"prev_searchtext"

@interface ConfigInfo : NSObject
{
    
}
@property (nonatomic) BOOL registered;
@property (nonatomic) NSString* appID;
@property (nonatomic) NSString* hostProsms;
@property (nonatomic) NSString* url;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* phone;
@property (nonatomic) NSString* email;
@property (nonatomic) NSString* accountNumber;
@property (nonatomic) BOOL accountBook;
@property (nonatomic) BOOL cashcardBook;

@property (nonatomic) NSString* helpDeskNumber;
@property (nonatomic) BOOL skipPayment;
@property (nonatomic) BOOL cach;
@property (nonatomic) NSString* prevSearchText;

+(ConfigInfo*)getInstance;

-(void)load;
-(void)save;
@end
