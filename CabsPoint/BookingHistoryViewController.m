//
//  BookingHistoryViewController.m
//  CabsPoint
//
//  Created by Michael on 1/19/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "BookingHistoryViewController.h"
#import "ConfigInfo.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "HistoryItem.h"
#import "CancelRequestViewController.h"

@interface BookingHistoryViewController ()

@end

@implementation BookingHistoryViewController
{
    NSURLConnection* urlConnection, *cancelRequestConnection;
    UIAlertView* accountCreatedAlert;
    NSMutableData* responseData;
    MBProgressHUD* HUD;
    NSMutableArray* historyList;
    int nSelectedItem;
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
    
    m_btnBack.layer.cornerRadius = 3;
    m_btnBack.layer.borderWidth = 1;
    m_btnBack.layer.borderColor = [UIColor whiteColor].CGColor;

    NSString* post = @"";
    post = [post stringByAppendingFormat:@"action=%@", @"history"];
    post = [post stringByAppendingFormat:@"&appid=%@", CONFIG_INFO.appID];
    post = [post stringByAppendingFormat:@"&phone=%@", CONFIG_INFO.phone];
    post = [post stringByAppendingFormat:@"&sdb=%@", @"ideas4bd"];
    
    
    NSString* url = [NSString stringWithFormat:@"%@?%@", CONFIG_INFO.url, post];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelBooking:(NSString*)text
{
    NSString* post = @"";
    post = [post stringByAppendingFormat:@"action=%@", @"cancel_booking"];
    post = [post stringByAppendingFormat:@"&appid=%@", CONFIG_INFO.appID];
    post = [post stringByAppendingFormat:@"&phone=%@", CONFIG_INFO.phone];
    int cancelBookingId = ((HistoryItem*)historyList[nSelectedItem]).ID;
    post = [post stringByAppendingFormat:@"&bkid=%d", cancelBookingId];
    post = [post stringByAppendingFormat:@"&cancelReason=%@", text];
    
    
    NSString* url = [NSString stringWithFormat:@"%@?%@", CONFIG_INFO.url, post];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    cancelRequestConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(historyList == nil)
        return 0;
    return historyList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UILabel* pickupAddress = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 15)];
        [pickupAddress setTag:1];
        [pickupAddress setFont:[UIFont fontWithName:@"Helvetica Bold" size:11]];
        [pickupAddress setText:@"Pickup:"];
        [cell.contentView addSubview:pickupAddress];
        
        UILabel* pickupAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 280, 24)];
        [pickupAddressLabel setTag:2];
        [pickupAddressLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [cell.contentView addSubview:pickupAddressLabel];
        
        UILabel* dropAddress = [[UILabel alloc] initWithFrame:CGRectMake(5, 29, 30, 15)];
        [dropAddress setTag:3];
        [dropAddress setFont:[UIFont fontWithName:@"Helvetica Bold" size:11]];
        [dropAddress setText:@"Drop:"];
        [cell.contentView addSubview:dropAddress];
        
        UILabel* dropAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 29, 280, 24)];
        [dropAddressLabel setTag:4];
        [dropAddressLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [cell.contentView addSubview:dropAddressLabel];
        
        UILabel* companyName = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 150, 12)];
        [companyName setFont:[UIFont fontWithName:@"Helvetica Bold" size:11]];
        [companyName setTag:5];
        [cell.contentView addSubview:companyName];
        
        UILabel* pickupDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 62, 150, 12)];
        [pickupDate setTag:6];
        [pickupDate setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [cell.contentView addSubview:pickupDate];
        
        UIImageView* priceBackground = [[UIImageView alloc] initWithFrame:CGRectMake(270, 45, 40, 25)];
        [priceBackground setTag:7];
        [priceBackground setBackgroundColor:[UIColor colorWithRed:1.0 green:0.78 blue:0 alpha:1]];
        [cell.contentView addSubview:priceBackground];
        
        UILabel* priceLabel = [[UILabel alloc] initWithFrame:priceBackground.frame];
        [priceLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:12]];
        [priceLabel setTag:8];
        [priceLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:priceLabel];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(210, 45, 50, 25)];
        [cancelButton setTag:9 + indexPath.row];
        [cancelButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.78 blue:0 alpha:1]];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setFont:[UIFont fontWithName:@"Helvetica Bold" size:11]];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [cell.contentView addSubview:cancelButton];
        cancelButton.hidden = YES;
        [cancelButton addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel* pickupAddressLabel = (UILabel*)[cell.contentView viewWithTag:2];
    [pickupAddressLabel setText:((HistoryItem*)historyList[indexPath.row]).pickupAddress];
    [pickupAddressLabel sizeToFit];
    
    UILabel* dropAddressLabel = (UILabel*)[cell.contentView viewWithTag:4];
    [dropAddressLabel setText:((HistoryItem*)historyList[indexPath.row]).dropAddress];
    [dropAddressLabel sizeToFit];
    
    UILabel* companyName = (UILabel*)[cell.contentView viewWithTag:5];
    [companyName setText:((HistoryItem*)historyList[indexPath.row]).companyName];
    [companyName sizeToFit];
    
    UILabel* pickupDate = (UILabel*)[cell.contentView viewWithTag:6];
    [pickupDate setText:((HistoryItem*)historyList[indexPath.row]).pickupTime];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy hh:mm"];
    NSDate* date = [formatter dateFromString:((HistoryItem*)historyList[indexPath.row]).pickupTime];
    NSTimeInterval timeDifference = [date timeIntervalSinceNow];
    if(timeDifference > 30)
    {
        UIButton* cancelButton = (UIButton*)[cell.contentView viewWithTag:9 + indexPath.row];
        cancelButton.hidden = NO;
        
    }
    
    
    UILabel* priceLabel = (UILabel*)[cell.contentView viewWithTag:8];
    [priceLabel setText:[NSString stringWithFormat:@"$%0.1f", ((HistoryItem*)historyList[indexPath.row]).priceQuote]];
    
    
    return cell;
}
-(void)onCancel:(UIButton*)sender
{
    nSelectedItem = sender.tag - 9;
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        CancelRequestViewController* cancelRequest = [[CancelRequestViewController alloc] initWithNibName:@"CancelRequestViewController" bundle:nil];
        cancelRequest.bookingHistoryViewController = self;
        cancelRequest.m_pickupAddress = ((HistoryItem*)historyList[nSelectedItem]).pickupAddress;
        cancelRequest.m_dropAddress = ((HistoryItem*)historyList[nSelectedItem]).dropAddress;

        cancelRequest.providesPresentationContextTransitionStyle = YES;
        cancelRequest.definesPresentationContext = YES;
        [cancelRequest setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:cancelRequest animated:YES completion:nil];
    }else
    {
        CancelRequestViewController* cancelRequest = [[CancelRequestViewController alloc] initWithNibName:@"CancelRequestViewController" bundle:nil];
        cancelRequest.bookingHistoryViewController = self;
        cancelRequest.m_pickupAddress = ((HistoryItem*)historyList[nSelectedItem]).pickupAddress;
        cancelRequest.m_dropAddress = ((HistoryItem*)historyList[nSelectedItem]).dropAddress;
        self.navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.navigationController presentModalViewController:cancelRequest animated:NO];
        
    }

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self.m_tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
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
            NSArray* history = [dict objectForKey:@"info"];
            NSArray* item;
            HistoryItem* hItem;
            historyList = [[NSMutableArray alloc] init];
            for(int i = 0; i < history.count; i++)
            {
                item = history[i];
                hItem = [[HistoryItem alloc] init];
                hItem.ID = [item[0] integerValue];
                hItem.pickupAddress = item[1];
                hItem.dropAddress = item[2];
                hItem.companyName = item[3];
                hItem.priceQuote = [item[4] doubleValue];
                hItem.pickupTime = item[5];
                @try {
                    hItem.cancellable = [item[6] integerValue] == 0 ? false :true;
                }
                @catch (NSException *exception) {
                    
                }
                [historyList addObject:hItem];
                [self.m_tableView reloadData];
            }
        }
        NSLog(@"%@", responseText);
        [HUD hide:YES];
    }else if(connection == cancelRequestConnection)
    {
        NSString* responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary* dict = [responseText JSONValue];
        
        if([[dict objectForKey:@"success"] intValue] == 1)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Your booking has been cancelled successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [historyList removeObjectAtIndex:nSelectedItem];
            [self.m_tableView reloadData];
        }
        NSLog(@"%@", responseText);
        [HUD hide:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
}

@end
