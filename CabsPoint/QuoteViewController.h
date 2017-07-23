//
//  QuoteViewController.h
//  CabsPoint
//
//  Created by Michael on 1/19/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookingInformation;

@interface QuoteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>


@property (nonatomic, weak) IBOutlet UIButton* m_btnBack;
@property (nonatomic, weak) IBOutlet UISegmentedControl* m_segCategory;
@property (nonatomic, weak) IBOutlet UITableView* m_tableView;
@property (nonatomic, weak) BookingInformation* bookInfo;

-(IBAction)onBack:(id)sender;
-(IBAction)onSegCategory:(id)sender;
@end
