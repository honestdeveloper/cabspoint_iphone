//
//  ViewController.m
//  CabsPoint
//
//  Created by Michael on 1/15/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "ViewController.h"
#import "AgreementAlertView.h"
#import "MyProfileViewController.h"
#import "BookNowViewController.h"
#import "BookingHistoryViewController.h"
#import "RegistrationViewController.h"
#import "ConfigInfo.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIAlertView* termOfUseAlert;
    UIAlertView* informationAlert;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationController.navigationBar.hidden = YES;
    
    if(CONFIG_INFO.registered == false)
    {
        termOfUseAlert = [[UIAlertView alloc] initWithTitle:@"Term Of Use" message:@"" delegate:self cancelButtonTitle:@"I Agree" otherButtonTitles:nil, nil];
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(62, 20, 87, 16)];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
        
        [button addTarget:self action:@selector(onTermsOfTrading:) forControlEvents:UIControlEventTouchUpInside];
        //[button setAttributedTitle:str forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 300, 50)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [label setFrame:CGRectMake(30, -10, 245, 60)];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setNumberOfLines:10];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"By Clicking the 'I Agree' button you the customer confirm that you have read and agree to the Terms of Trading being incorportated in and forming prt of every contract for service."];
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(94,16)];
        [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(94,16)];
        
        [label setAttributedText:string];
        
        [view addSubview:label];
        [view addSubview:button];
        
        [termOfUseAlert setValue:view forKey:@"accessoryView"];
        [termOfUseAlert show];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == termOfUseAlert)
    {
        if(buttonIndex == 0)
        {
            informationAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter your details and the payment that you prefer before making a  booking" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [informationAlert show];
        }
    }else if(alertView == informationAlert)
    {
        
        if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            RegistrationViewController* registration = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
            registration.viewController = self;
            
            registration.providesPresentationContextTransitionStyle = YES;
            registration.definesPresentationContext = YES;
            [registration setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [self.navigationController presentViewController:registration animated:YES completion:nil];
        }else
        {
            RegistrationViewController* registration = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
            registration.viewController = self;
            self.navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self.navigationController presentModalViewController:registration animated:NO];

        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}
-(IBAction)onMyProfile:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyProfileViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
}
-(IBAction)onBookingHistory:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookingHistoryViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"BookingHistoryViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)onGetQuotes:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookNowViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"BookNowViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)onTermsOfTrading:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cabspoint.com/terms-conditions"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
