//
//  CancelRequestViewController.m
//  CabsPoint
//
//  Created by Brian on 2/26/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "CancelRequestViewController.h"
#import "BookingHistoryViewController.h"

@interface CancelRequestViewController ()

@end

@implementation CancelRequestViewController
{
    NSURLConnection* urlConnection;
    NSMutableData* responseData;
}

@synthesize m_contentView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [m_contentView.layer setCornerRadius:2];
    [m_contentView.layer setBorderWidth:1];
    [m_contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [m_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
    [m_contentView.layer setShadowOpacity:0.8];
    [m_contentView.layer setShadowRadius:3.0];
    [m_contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    self.m_lblInfo.text = [NSString stringWithFormat:@"Please specify a reason to cancel your booking for the journey from %@ to %@.", self.m_pickupAddress, self.m_dropAddress];
    [self.m_lblInfo sizeToFit];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.m_lblInfo sizeToFit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)onCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(IBAction)onOK:(id)sender
{
    [self.bookingHistoryViewController cancelBooking:self.m_txtReason.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
