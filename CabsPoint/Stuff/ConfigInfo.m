//
//  ConfigInfo.m
//  CabsPoint
//
//  Created by Michael on 1/19/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "ConfigInfo.h"

static ConfigInfo* g_configInfo = nil;

@implementation ConfigInfo

-(id)init
{
    self = [super init];
    if(self)
    {
        self.registered = false;
        NSUUID* deviceId;
        deviceId = [UIDevice currentDevice].identifierForVendor;
        self.appID = [deviceId UUIDString];
        NSCharacterSet* notAllowedChars = [NSCharacterSet characterSetWithCharactersInString:@"-"];
        self.appID = [[self.appID componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        
        
        
        self.hostProsms = @"cabspoint.eu/app/webroot/mobileapp";
        self.url = @"http://";
        self.url = [self.url stringByAppendingFormat:@"%@/index.php", self.hostProsms];
        self.name = @"";
        self.phone = @"";
        self.email = @"";
        self.accountNumber = @"Account Number";
        self.accountBook = false;
        self.cashcardBook = true;
        self.helpDeskNumber = @"02078427009";
        self.skipPayment = true;
        self.prevSearchText = @"";
        
        [self load];
    }
    return self;
}
-(void)load
{
    NSNumber* registeredValue = [[NSUserDefaults standardUserDefaults] objectForKey:REGISTERED_KEY];
    if(registeredValue != nil)
        self.registered = [registeredValue boolValue];
    //NSString* appIDValue = [[NSUserDefaults standardUserDefaults] stringForKey:APP_ID_KEY];
    //if(appIDValue != nil)
    //    self.appID = appIDValue;
    
    NSString* hostProsmsValue = [[NSUserDefaults standardUserDefaults] stringForKey:HOST_PROSMS_KEY];
    if(hostProsmsValue != nil)
        self.hostProsms = hostProsmsValue;
    
    NSString* nameValue = [[NSUserDefaults standardUserDefaults] stringForKey:NAME_KEY];
    if(nameValue != nil)
        self.name = nameValue;
    
    NSString* phoneValue = [[NSUserDefaults standardUserDefaults] stringForKey:PHONE_KEY];
    if(phoneValue != nil)
        self.phone = phoneValue;
    
    NSString* emailValue = [[NSUserDefaults standardUserDefaults] stringForKey:EMAIL_KEY];
    if(emailValue != nil)
        self.email = emailValue;
    
    NSString* accountNumber = [[NSUserDefaults standardUserDefaults] stringForKey:ACCOUNT_NUMBER_KEY];
    if(accountNumber != nil)
        self.accountNumber = accountNumber;
    
    NSNumber* accountBook = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_BOOK_KEY];
    if(accountBook != nil)
        self.accountBook = [accountBook boolValue];
    
    NSNumber* cashcardBook = [[NSUserDefaults standardUserDefaults] objectForKey:CASHCARD_BOOK_KEY];
    if(cashcardBook != nil)
        self.cashcardBook = [cashcardBook boolValue];
    
    NSString* helpDeskNumber = [[NSUserDefaults standardUserDefaults] stringForKey:HELPDESKNUMBER_KEY];
    if(helpDeskNumber != nil)
        self.helpDeskNumber = helpDeskNumber;
    
    NSNumber* skipPayment = [[NSUserDefaults standardUserDefaults] objectForKey:SKIP_PAYMENT_KEY];
    if(skipPayment != nil)
        self.skipPayment = [skipPayment boolValue];
    
    NSString* prevSearchText = [[NSUserDefaults standardUserDefaults] stringForKey:PREV_SEARCHTEXT_KEY];
    if(prevSearchText != nil)
        self.prevSearchText = prevSearchText;
        
}
-(void)save
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.registered] forKey:REGISTERED_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.appID forKey:APP_ID_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.hostProsms forKey:HOST_PROSMS_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:NAME_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.phone forKey:PHONE_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.email forKey:EMAIL_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accountNumber forKey:ACCOUNT_NUMBER_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.accountBook] forKey:ACCOUNT_BOOK_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.cashcardBook] forKey:CASHCARD_BOOK_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.helpDeskNumber forKey:HELPDESKNUMBER_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.skipPayment] forKey:SKIP_PAYMENT_KEY];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.prevSearchText forKey:PREV_SEARCHTEXT_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(ConfigInfo*)getInstance
{
    if(g_configInfo == nil)
    {
        g_configInfo = [[self alloc] init];
    }
    return g_configInfo;
}
@end
