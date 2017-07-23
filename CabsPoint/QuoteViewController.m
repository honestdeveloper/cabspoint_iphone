//
//  QuoteViewController.m
//  CabsPoint
//
//  Created by Michael on 1/19/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "QuoteViewController.h"
#import "ConfigInfo.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "BookingInformation.h"
#import "QuoteItem.h"
#import "PPRatingBar.h"
#import "PaymentMethodViewController.h"

@interface QuoteViewController ()

@end

@implementation QuoteViewController
{
    NSURLConnection* urlConnection;
    UIAlertView* accountCreatedAlert;
    NSMutableData* responseData;
    MBProgressHUD* HUD;
    NSMutableArray* quoteCategories;
}
@synthesize m_btnBack, m_segCategory, m_tableView;

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
    
    [m_segCategory setSelectedSegmentIndex:0];
    
    quoteCategories = [[NSMutableArray alloc] init];
    
    m_btnBack.layer.cornerRadius = 3;
    m_btnBack.layer.borderWidth = 1;
    m_btnBack.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSString* post = @"";
    post = [post stringByAppendingFormat:@"action=%@", @"auto_quotes"];
    post = [post stringByAppendingFormat:@"&appid=%@", CONFIG_INFO.appID];
    post = [post stringByAppendingFormat:@"&phone=%@", CONFIG_INFO.phone];
    post = [post stringByAppendingFormat:@"&from=%@", self.bookInfo.pickupPostCode];
    post = [post stringByAppendingFormat:@"&to=%@", self.bookInfo.dropPostCode];
    post = [post stringByAppendingFormat:@"&passengers=%d", self.bookInfo.passengerCount];
    post = [post stringByAppendingFormat:@"&luggage=%d", self.bookInfo.suitcaseCount];
    post = [post stringByAppendingFormat:@"&chseats=%@", self.bookInfo.hasChildSeat ? @"1" : @"0"];
    post = [post stringByAppendingFormat:@"&wChair=%@", self.bookInfo.hasWheelChair ? @"1" : @"0"];
    post = [post stringByAppendingFormat:@"&petFriendly=%@", self.bookInfo.isPetFriendly ? @"1" : @"0"];
    
    if(self.bookInfo.isASAP)
    {
        post = [post stringByAppendingFormat:@"&pickupDate=%@", @"ASAP"];
    }else
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        NSString* stringFromDate = [formatter stringFromDate:self.bookInfo.pickupDateTime];
        post = [post stringByAppendingFormat:@"&pickupDate=%@", stringFromDate ];
    }

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

-(IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            quoteCategories = [[NSMutableArray alloc] init];
            QuoteItem* qItem;
            NSMutableArray* quoteList;
            NSArray* item;
            NSDictionary* quotes = [dict objectForKey:@"quotes"];
            NSDictionary* quotesInfo = [quotes objectForKey:@"quoteInfo"];
            NSArray* categories = [quotes objectForKey:@"categories"];
            for(int i = 0; i < categories.count; i++)
            {
                NSArray* comIds = categories[i];
                quoteList = [[NSMutableArray alloc] init];
                for(int j = 0; j < comIds.count; j++)
                {
                    int comId = [comIds[j] intValue];
                    item = [quotesInfo objectForKeyedSubscript:[NSString stringWithFormat:@"%d", comId]];
                    qItem = [[QuoteItem alloc] init];
                    qItem.ID = [item[0] integerValue];
                    qItem.companyName = item[1];
                    qItem.onTime = [item[2] integerValue];
                    qItem.priceQuote = [item[3] doubleValue];
                    qItem.timeLimit = [item[4] integerValue];
                    qItem.ratingBarPoint = [item[5] doubleValue];
                    qItem.companyStatus = [item[6] integerValue];
                    qItem.priceDetails = item[7];
                    qItem.startTime = [item[8] longValue];
                    qItem.carType = [item[9] integerValue];
                    [quoteList addObject:qItem];
                }
                [quoteCategories addObject:quoteList];
            }
            [m_tableView reloadData];
        }
        NSLog(@"%@", responseText);
        [HUD hide:YES];
    }
}


#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(quoteCategories.count != 3)
        return 0;
    NSMutableArray* quoteList = [quoteCategories objectAtIndex:m_segCategory.selectedSegmentIndex];
    if(quoteList == nil)
        return 0;
    return quoteList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Quote"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Quote"];
        
        if(quoteCategories.count != 3)
            return cell;
        NSMutableArray* quoteList = [quoteCategories objectAtIndex:m_segCategory.selectedSegmentIndex];
        if(quoteList == nil)
            return cell;

        UILabel* companyName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 250, 20)];
        [companyName setTag:1];
        [companyName setFont:[UIFont systemFontOfSize:13]];
        [companyName setText:((QuoteItem*)quoteList[indexPath.row]).companyName];
        
        UILabel* onTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, 250, 20)];
        [onTime setTag:2];
        [onTime setFont:[UIFont systemFontOfSize:13]];
        [onTime setText:[NSString stringWithFormat:@"On time: %d", ((QuoteItem*)quoteList[indexPath.row]).onTime]];
        
        [cell.contentView addSubview:companyName];
        [cell.contentView addSubview:onTime];
        
        PPRatingBar* ratingBar = [[PPRatingBar alloc] initWithFrame:CGRectMake(55, 43, 60, 20)];
        [ratingBar setTag:3];
        [cell.contentView addSubview:ratingBar];
        
        UILabel* ratingBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, 60, 20)];
        [ratingBarLabel setTag:4];
        [ratingBarLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:ratingBarLabel];
        
        UIView* priceBackground = [[UIView alloc] initWithFrame:CGRectMake(200, 10, 100, 40)];
        [priceBackground setTag:5];
        [priceBackground setBackgroundColor:[UIColor colorWithRed:1.0 green:0.78 blue:0 alpha:1]];
        [cell.contentView addSubview:priceBackground];
        
        UILabel* priceLabel = [[UILabel alloc] initWithFrame:priceBackground.frame];
        [priceLabel setTag:6];
        [priceLabel setTextAlignment:NSTextAlignmentCenter];
        [priceLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:13]];
        [cell.contentView addSubview:priceLabel];
        
        UILabel* timeLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 50, 100, 20)];
        [timeLimitLabel setTag:7];
        [timeLimitLabel setFont:[UIFont systemFontOfSize:12]];
        [timeLimitLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:timeLimitLabel];
    }
    
    if(quoteCategories.count != 3)
        return cell;
    NSMutableArray* quoteList = [quoteCategories objectAtIndex:m_segCategory.selectedSegmentIndex];
    if(quoteList == nil)
        return cell;
    
    UILabel* companyName = (UILabel*)[cell.contentView viewWithTag:1];
    [companyName setText:((QuoteItem*)quoteList[indexPath.row]).companyName];
    
    UILabel* onTime = (UILabel*)[cell.contentView viewWithTag:2];
    [onTime setText:[NSString stringWithFormat:@"On time: %d", ((QuoteItem*)quoteList[indexPath.row]).onTime]];
    
    UILabel* ratingBarLabel = (UILabel*)[cell.contentView viewWithTag:4];
    [ratingBarLabel setText:@"Rating:"];
    
    PPRatingBar* ratingBar = (PPRatingBar*)[cell.contentView viewWithTag:3];
    [ratingBar setRating:((QuoteItem*)quoteList[indexPath.row]).ratingBarPoint];
    
    UILabel* priceLabel = (UILabel*)[cell.contentView viewWithTag:6];
    [priceLabel setText:[NSString stringWithFormat:@"£%0.1f", ((QuoteItem*)quoteList[indexPath.row]).priceQuote]];
    
    UILabel* timeLimitLabel = (UILabel*)[cell.contentView viewWithTag:7];
    [timeLimitLabel setText:[NSString stringWithFormat:@"Within %d minutes",((QuoteItem*)quoteList[indexPath.row]).timeLimit]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(quoteCategories.count != 3)
        return;
    NSMutableArray* quoteList = [quoteCategories objectAtIndex:m_segCategory.selectedSegmentIndex];
    if(quoteList == nil)
        return;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PaymentMethodViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"PaymentMethodViewController"];
    controller.quote = quoteList[indexPath.row];
    controller.bookInfo = self.bookInfo;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(IBAction)onSegCategory:(id)sender
{
    [m_tableView reloadData];
}
@end
