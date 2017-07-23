//
//  PaymentMethodViewController.m
//  CabsPoint
//
//  Created by Michael on 1/18/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "QuoteItem.h"
#import "RadioButton.h"
#import "ConfirmBookingViewController.h"

@interface PaymentMethodViewController ()

@end

@implementation PaymentMethodViewController

@synthesize m_btnBack, m_btnCancel, m_priceLabel1, m_priceLabel2, m_rbtnPayCard, m_rbtnPayCash;

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
    
    m_btnBack.layer.cornerRadius = 3;
    m_btnBack.layer.borderWidth = 1;
    m_btnBack.layer.borderColor = [UIColor whiteColor].CGColor;
    
    m_btnCancel.layer.cornerRadius = 3;
    m_btnCancel.layer.borderWidth = 1;
    m_btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [m_priceLabel1 setText:[NSString stringWithFormat:@"£%0.1f", self.quote.priceQuote]];
    [m_priceLabel2 setText:[NSString stringWithFormat:@"£%0.1f", self.quote.priceQuote]];
    
    m_priceLabel2.hidden = YES;
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
-(IBAction)onContinue:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConfirmBookingViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"ConfirmBookingViewController"];
    controller.bookInfo = self.bookInfo;
    controller.quoteItem = self.quote;
    [self.navigationController pushViewController:controller animated:YES];
    if([m_rbtnPayCash isSelected])
    {
        controller.bPayCard = false;
    }else
    {
        controller.bPayCard = true;
    }
}
-(IBAction)onPayByCardClick:(id)sender
{
    m_priceLabel1.hidden = YES;
    m_priceLabel2.hidden = NO;
}
-(IBAction)onPayByCashClick:(id)sender
{
    m_priceLabel1.hidden = NO;
    m_priceLabel2.hidden = YES;
}
@end
