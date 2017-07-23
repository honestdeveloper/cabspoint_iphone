//
//  MyProfileViewController.m
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ConfigInfo.h"
#import "JSON.h"
#import "MBProgressHUD.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController
{
    NSURLConnection* urlConnection;
    UIAlertView* accountCreatedAlert;
    NSMutableData* responseData;
    MBProgressHUD* HUD;
}
@synthesize m_txtEmail, m_txtName, m_txtPhone, m_swtAccountBookings, m_swtCashCardBookings;

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
    
    m_txtPhone.text = CONFIG_INFO.phone;
    m_txtEmail.text = CONFIG_INFO.email;
    m_txtName.text = CONFIG_INFO.name;
    [m_swtAccountBookings setOn:CONFIG_INFO.accountBook];
    [m_swtCashCardBookings setOn:CONFIG_INFO.cashcardBook];
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onSave:(id)sender
{
    if(![self validateForm])
    {
        return;
    }
    NSString* post = [NSString stringWithFormat:@"action=save_profile&appid=%@&name=%@&phone=%@&email=%@&accountBooking=%@&accountNumber=%@&cashCardBooking=%@&registeredBy=%@", CONFIG_INFO.appID, m_txtName.text, m_txtPhone.text, m_txtEmail.text, m_swtAccountBookings.on ? @"TRUE" : @"FALSE", CONFIG_INFO.accountNumber, m_swtCashCardBookings.on ? @"TRUE" : @"FALSE", @"TESTER"];
    
   
    //NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    NSString* url = [NSString stringWithFormat:@"%@?%@", CONFIG_INFO.url, post];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //[request setURL:[NSURL URLWithString:url]];
    //[request setHTTPMethod:@"POST"];
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[request setHTTPBody:postData];

    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    if(CONFIG_INFO.registered)
        HUD.labelText = @"Saving profile information...";
    else
        HUD.labelText = @"Creating account...";
    //HUD.detailsLabelText = @"Creating Account...";
    //HUD.square = YES;
    [HUD show:YES];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    if(connection == urlConnection)
    {
        NSString* responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary* dict = [responseText JSONValue];
        if([[dict objectForKey:@"success"] intValue] == 1)
        {
           
            {
                accountCreatedAlert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Account has been created successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            }
            
            [accountCreatedAlert show];
            CONFIG_INFO.registered = true;
            [self saveValues];
        }
        NSLog(@"%@", responseText);
        [HUD hide:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == accountCreatedAlert)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)saveValues
{
    CONFIG_INFO.name = m_txtName.text;
    CONFIG_INFO.email = m_txtEmail.text;
    CONFIG_INFO.phone = m_txtPhone.text;
    CONFIG_INFO.accountBook = m_swtAccountBookings.on;
    CONFIG_INFO.cashcardBook = m_swtCashCardBookings.on;
    [CONFIG_INFO save];
}
-(BOOL)validateForm
{
    if(m_txtName.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Name must not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        for (UIView *view in alert.subviews) {
            if([[view class] isSubclassOfClass:[UILabel class]]) {
                ((UILabel*)view).textAlignment = NSTextAlignmentLeft;
            }
        }
        [alert show];
        return false;
    }else
    {
        
    }
    
    if(m_txtPhone.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Phone must not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        for (UIView *view in alert.subviews) {
            if([[view class] isSubclassOfClass:[UILabel class]]) {
                ((UILabel*)view).textAlignment = NSTextAlignmentLeft;
            }
        }
        [alert show];
        return false;
    }else
    {
        
    }
    if(m_txtEmail.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email must not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        for (UIView *view in alert.subviews) {
            if([[view class] isSubclassOfClass:[UILabel class]]) {
                ((UILabel*)view).textAlignment = NSTextAlignmentLeft;
            }
        }
        [alert show];
        return false;
    }else
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if(![emailTest evaluateWithObject:m_txtEmail.text])
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            for (UIView *view in alert.subviews) {
                if([[view class] isSubclassOfClass:[UILabel class]]) {
                    ((UILabel*)view).textAlignment = NSTextAlignmentLeft;
                }
            }
            [alert show];
            return false;
        }
    }
    return true;
}
@end
