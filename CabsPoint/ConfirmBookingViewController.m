//
//  ConfirmBookingViewController.m
//  CabsPoint
//
//  Created by Michael on 1/19/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "ConfirmBookingViewController.h"
#import "BookingInformation.h"
#import "QuoteItem.h"
#import "ConfigInfo.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "AFNetworking.h"
#import "Braintree/Braintree.h"

@interface ConfirmBookingViewController () <BTDropInViewControllerDelegate>

@end

@implementation ConfirmBookingViewController
{
    NSURLConnection* confirmBookingConnection;
    NSURLConnection* paymentByCardConnection;
    UIAlertView* accountCreatedAlert;
    NSMutableData* responseData;
    MBProgressHUD* HUD;
    UIAlertView* bookingAlert;
    int bookingId;
    AFHTTPRequestOperationManager *manager;
    NSString* clientToken;
}

@synthesize m_btnBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bookingId = -1;
    
    m_btnBack.layer.cornerRadius = 3;
    m_btnBack.layer.borderWidth = 1;
    m_btnBack.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    self.m_lblPickupAddress.text = [NSString stringWithFormat:@"Pickup: %@", self.bookInfo.pickupAddress1];
    self.m_lblSmallPickupAddress.text = self.bookInfo.pickupAddress1;
    self.m_lblPickupPostCode.text = self.bookInfo.pickupPostCode;
    self.m_lblDropAddress.text = [NSString stringWithFormat:@"Drop: %@",self.bookInfo.dropAddress1];
    self.m_lblSmallDropAddress.text = self.bookInfo.dropAddress1;
    self.m_lblDropPostCode.text = self.bookInfo.dropPostCode;
    self.m_lblTotalPrice.text = [NSString stringWithFormat:@"£%0.1f(%@)", self.quoteItem.priceQuote, self.bPayCard ? @"card" : @"cash"];
    self.m_lblBookingTime.text = self.bookInfo.isASAP ? @":ASAP" : [NSString stringWithFormat:@":%@", self.bookInfo.pickupDateTime];
    self.m_lblPassengerCount.text = [NSString stringWithFormat:@":%d",  self.bookInfo.passengerCount];
    self.m_lblContactName.text = [NSString stringWithFormat:@":%@", CONFIG_INFO.name];
    self.m_lblContactPhone.text = [NSString stringWithFormat:@":%@", CONFIG_INFO.phone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onConfirmBooking:(id)sender
{
    /*
    if(self.bPayCard)
    {
        NSString* post = @"";
        post = [post stringByAppendingFormat:@"action=%@", @"confirm_booking"];
        post = [post stringByAppendingFormat:@"&appid=%@", CONFIG_INFO.appID];
        post = [post stringByAppendingFormat:@"&phone=%@", CONFIG_INFO.phone];
        post = [post stringByAppendingFormat:@"&from=%@", self.bookInfo.pickupPostCode];
        post = [post stringByAppendingFormat:@"&to=%@", self.bookInfo.dropPostCode];
        post = [post stringByAppendingFormat:@"&paytype=%@", self.bPayCard ? @"card" : @"cash"];
        post = [post stringByAppendingFormat:@"&comId=%d", self.quoteItem.ID];
        post = [post stringByAppendingFormat:@"&price=%f", self.quoteItem.priceQuote];
        post = [post stringByAppendingFormat:@"&car_category=%d", self.quoteItem.carType];
        post = [post stringByAppendingFormat:@"&paymentMethodNonce=%@", @""];
        post = [post stringByAppendingFormat:@"&bookingId=%@", ];
    }else */
    {
        NSString* post = @"";
        post = [post stringByAppendingFormat:@"action=%@", @"confirm_booking"];
        post = [post stringByAppendingFormat:@"&appid=%@", CONFIG_INFO.appID];
        post = [post stringByAppendingFormat:@"&phone=%@", CONFIG_INFO.phone];
        post = [post stringByAppendingFormat:@"&from=%@", [self convert2Address4Server:@"pickup"]];
        post = [post stringByAppendingFormat:@"&to=%@", [self convert2Address4Server:@"drop"]];
        if(self.bookInfo.viaPostCode.length != 0)
        {
            post = [post stringByAppendingFormat:@"&via=%@", [self convert2Address4Server:@"via"]];
        }
        
        post = [post stringByAppendingFormat:@"&passengers=%d", self.bookInfo.passengerCount];
        post = [post stringByAppendingFormat:@"&luggage=%d", self.bookInfo.suitcaseCount];
        post = [post stringByAppendingFormat:@"&chseats=%@", self.bookInfo.hasChildSeat ? @"1" : @"0"];
        post = [post stringByAppendingFormat:@"&wChair=%@", self.bookInfo.hasWheelChair ? @"1" : @"0"];
        post = [post stringByAppendingFormat:@"&petFriendly=%@", self.bookInfo.isPetFriendly ? @"1" : @"0"];
        post = [post stringByAppendingFormat:@"&notes=%@", self.bookInfo.comment];
        
        post = [post stringByAppendingFormat:@"&paytype=%@", self.bPayCard ? @"card" : @"cash"];
        post = [post stringByAppendingFormat:@"&comId=%d", self.quoteItem.ID];
        post = [post stringByAppendingFormat:@"&price=%f", self.quoteItem.priceQuote];
        post = [post stringByAppendingFormat:@"&priceDetail=%@", self.quoteItem.priceDetails];
        post = [post stringByAppendingFormat:@"&start=%ld", self.quoteItem.startTime];
        
        post = [post stringByAppendingFormat:@"&car_category=%d", self.quoteItem.carType];
        post = [post stringByAppendingFormat:@"&retTflag=%d", self.quoteItem.retTflag];
        //post = [post stringByAppendingFormat:@"&paymentMethodNonce=%@", @""];
        if(self.bookInfo.isASAP)
        {
            post = [post stringByAppendingFormat:@"&pickupDate=%@", @"ASAP"];
        }else
        {
            //post = [post stringByAppendingFormat:@"&pickupDate=%@", ];
        }
        
        
        NSString* url = [NSString stringWithFormat:@"%@?%@", CONFIG_INFO.url, post];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        
        confirmBookingConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        responseData = [[NSMutableData alloc] init];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Please wait...";
        [HUD show:YES];

    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    if(connection == confirmBookingConnection)
    {
        
        UIAlertView* alert;
        NSString* message = @"Connection Failed";
        alert = [[UIAlertView alloc] initWithTitle:@"Booking Confirmation" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HUD hide:YES];
    }else if(connection == paymentByCardConnection)
    {
        UIAlertView* alert;
        NSString* message = @"Connection Failed";
        alert = [[UIAlertView alloc] initWithTitle:@"Payment" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HUD hide:YES];
    }
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    if(connection == confirmBookingConnection)
    {
        NSString* responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary* dict = [responseText JSONValue];
        
        if([[dict objectForKey:@"success"] intValue] == 1)
        {
            if(self.bPayCard)
            {
                NSDictionary* info = [dict objectForKey:@"info"];
                bookingId = [[info objectForKey:@"bookingId"] intValue];
                clientToken = [info objectForKey:@"token"];
                [self startPayment:clientToken];
            }else
            {
                NSString* message = [dict objectForKey:@"info"];
                NSScanner *theScanner;
                NSString *text = nil;
                theScanner = [NSScanner scannerWithString: message];
                while ([theScanner isAtEnd] == NO) {
                    // find start of tag
                    [theScanner scanUpToString: @"<" intoString: NULL];
                    // find end of tag
                    [theScanner scanUpToString: @">" intoString: &text];
                    // replace the found tag with a space
                    //(you can filter multi-spaces out later if you wish)
                    message = [message stringByReplacingOccurrencesOfString:
                            [NSString stringWithFormat: @"%@>", text]
                                                           withString: @""];
                } // while //
                
                bookingAlert = [[UIAlertView alloc] initWithTitle:@"Booking Confirmation" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [bookingAlert show];
            }
        }
        NSLog(@"%@", responseText);
        [HUD hide:YES];
    }else if(connection == paymentByCardConnection)
    {
        NSString* responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary* dict = [responseText JSONValue];
        
        if([[dict objectForKey:@"success"] intValue] == 1)
        {
            NSString* message = [dict objectForKey:@"info"];
            
            NSScanner *theScanner;
            NSString *text = nil;
            theScanner = [NSScanner scannerWithString: message];
            while ([theScanner isAtEnd] == NO) {
                // find start of tag
                [theScanner scanUpToString: @"<" intoString: NULL];
                // find end of tag
                [theScanner scanUpToString: @">" intoString: &text];
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)
                message = [message stringByReplacingOccurrencesOfString:
                           [NSString stringWithFormat: @"%@>", text]
                                                             withString: @""];
            } // while //

            bookingAlert = [[UIAlertView alloc] initWithTitle:@"Booking Confirmation" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [bookingAlert show];

        }
        NSLog(@"%@", responseText);
        [HUD hide:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == bookingAlert)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - BrainTree

-(void)startPayment:(NSString*)token
{
    Braintree *braintree = [Braintree braintreeWithClientToken:token];
    BTDropInViewController *dropInViewController = [braintree dropInViewControllerWithDelegate:self];
    [dropInViewController setDelegate:self];
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                             target:self
                                                             action:@selector(userDidCancelPayment)];
    
    //Customize the UI
    dropInViewController.summaryTitle = @"Pay by Card";
    dropInViewController.summaryDescription = @"";
    dropInViewController.displayAmount = [NSString stringWithFormat:@"£%0.1f", self.quoteItem.priceQuote];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];

}
- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    //[self postNonceToServer:paymentMethod.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString* post = @"";
    post = [post stringByAppendingFormat:@"action=%@", @"payment"];
    post = [post stringByAppendingFormat:@"&appid=%@", CONFIG_INFO.appID];
    post = [post stringByAppendingFormat:@"&phone=%@", CONFIG_INFO.phone];
    post = [post stringByAppendingFormat:@"&from=%@", [self convert2Address4Server:@"pickup"]];
    post = [post stringByAppendingFormat:@"&to=%@", [self convert2Address4Server:@"drop"]];
    if(self.bookInfo.viaPostCode.length != 0)
    {
        post = [post stringByAppendingFormat:@"&via=%@", [self convert2Address4Server:@"via"]];
    }
    

    
    post = [post stringByAppendingFormat:@"&paytype=%@", self.bPayCard ? @"card" : @"cash"];
    post = [post stringByAppendingFormat:@"&comId=%d", self.quoteItem.ID];
    post = [post stringByAppendingFormat:@"&price=%f", self.quoteItem.priceQuote];
    post = [post stringByAppendingFormat:@"&car_category=%d", self.quoteItem.carType];
    post = [post stringByAppendingFormat:@"&paymentMethodNonce=%@", paymentMethod.nonce];
    post = [post stringByAppendingFormat:@"&bookingId=%d", bookingId];
    
    
    NSString* url = [NSString stringWithFormat:@"%@?%@", CONFIG_INFO.url, post];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    paymentByCardConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];

}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) userDidCancelPayment{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString*)convert2Address4Server:(NSString*)type
{
    NSString* address = @"";
    if([type compare:@"pickup"] == NSOrderedSame)
    {
        if(self.bookInfo.pickupFlightNumber.length > 0)
        {
            address = [address stringByAppendingFormat:@"Flight#%@, ", self.bookInfo.pickupFlightNumber];
        }
        if(self.bookInfo.pickupEditAddress.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.pickupEditAddress];
        }
        if(self.bookInfo.pickupAddress1.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.pickupAddress1];
        }
        if(self.bookInfo.pickupTown.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.pickupTown];
        }
        if(self.bookInfo.pickupPostCode.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.pickupPostCode];
        }
    }else if([type compare:@"drop"] == NSOrderedSame)
    {
        if(self.bookInfo.dropEditAddress.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.dropEditAddress];
        }
        if(self.bookInfo.dropAddress1.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.dropAddress1];
        }
        if(self.bookInfo.dropTown.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.dropTown];
        }
        if(self.bookInfo.dropPostCode.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.dropPostCode];
        }

    }else if([type compare:@"via"] == NSOrderedSame)
    {
        if(self.bookInfo.viaEditAddress.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.viaEditAddress];
        }
        if(self.bookInfo.viaAddress1.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.viaAddress1];
        }
        if(self.bookInfo.viaTown.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.viaTown];
        }
        if(self.bookInfo.viaPostCode.length > 0)
        {
            address = [address stringByAppendingFormat:@"%@, ", self.bookInfo.viaPostCode];
        }
        
    }
    if(address.length > 0)
    {
        address = [address substringWithRange:NSMakeRange(0, address.length - 2)];
    }
    return address;
}
@end
