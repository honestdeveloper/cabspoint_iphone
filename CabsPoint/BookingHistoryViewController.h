//
//  BookingHistoryViewController.h
//  CabsPoint
//
//  Created by Michael on 1/19/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BookingHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton* m_btnBack;
@property (nonatomic, weak) IBOutlet UITableView* m_tableView;

-(IBAction)onBack:(id)sender;
-(void)cancelBooking:(NSString*)text;
@end
