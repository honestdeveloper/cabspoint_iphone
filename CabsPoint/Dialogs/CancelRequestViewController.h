//
//  CancelRequestViewController.h
//  CabsPoint
//
//  Created by Brian on 2/26/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookingHistoryViewController;
@interface CancelRequestViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView* m_contentView;
@property (nonatomic, weak) IBOutlet UIButton* m_btnCancel;
@property (nonatomic, weak) IBOutlet UIButton* m_btnOK;
@property (nonatomic, weak) IBOutlet UITextField* m_txtReason;
@property (nonatomic, weak) IBOutlet UILabel* m_lblInfo;
@property (nonatomic, weak)  NSString* m_pickupAddress;
@property (nonatomic, weak)  NSString* m_dropAddress;
@property (nonatomic, weak) BookingHistoryViewController* bookingHistoryViewController;
-(IBAction)onCancel:(id)sender;
-(IBAction)onOK:(id)sender;
@end
