//
//  PaymentMethodViewController.h
//  CabsPoint
//
//  Created by Michael on 1/18/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuoteItem;
@class RadioButton;
@class BookingInformation;

@interface PaymentMethodViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton* m_btnBack;
@property (nonatomic, weak) IBOutlet UIButton* m_btnCancel;
@property (nonatomic, weak) IBOutlet UILabel* m_priceLabel1;
@property (nonatomic, weak) IBOutlet UILabel* m_priceLabel2;
@property (nonatomic, weak) IBOutlet RadioButton* m_rbtnPayCash;
@property (nonatomic, weak) IBOutlet RadioButton* m_rbtnPayCard;
@property (nonatomic) QuoteItem* quote;

@property (nonatomic) BookingInformation* bookInfo;

-(IBAction)onContinue:(id)sender;
-(IBAction)onPayByCardClick:(id)sender;
-(IBAction)onPayByCashClick:(id)sender;
-(IBAction)onBack:(id)sender;
@end
