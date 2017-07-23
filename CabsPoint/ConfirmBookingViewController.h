//
//  ConfirmBookingViewController.h
//  CabsPoint
//
//  Created by Michael on 1/19/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class BookingInformation;
@class QuoteItem;
@interface ConfirmBookingViewController : UIViewController <NSURLConnectionDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton* m_btnBack;
@property (nonatomic, weak) IBOutlet UIButton* m_btnConfirmBooking;
@property (nonatomic, weak) IBOutlet UILabel* m_lblPickupAddress;
@property (nonatomic, weak) IBOutlet UILabel* m_lblSmallPickupAddress;
@property (nonatomic, weak) IBOutlet UILabel* m_lblPickupPostCode;
@property (nonatomic, weak) IBOutlet UILabel* m_lblDropAddress;
@property (nonatomic, weak) IBOutlet UILabel* m_lblSmallDropAddress;
@property (nonatomic, weak) IBOutlet UILabel* m_lblDropPostCode;
@property (nonatomic, weak) IBOutlet UILabel* m_lblTotalPrice;
@property (nonatomic, weak) IBOutlet UILabel* m_lblBookingTime;
@property (nonatomic, weak) IBOutlet UILabel* m_lblPassengerCount;
@property (nonatomic, weak) IBOutlet UILabel* m_lblContactName;
@property (nonatomic, weak) IBOutlet UILabel* m_lblContactPhone;


@property (nonatomic) BOOL bPayCard;
@property (nonatomic) BookingInformation* bookInfo;
@property (nonatomic) QuoteItem* quoteItem;

-(IBAction)onBack:(id)sender;
-(IBAction)onConfirmBooking:(id)sender;

@end
