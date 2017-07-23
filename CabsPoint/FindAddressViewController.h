//
//  FindAddressViewController.h
//  CabsPoint
//
//  Created by Michael on 1/18/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#import "BookNowViewController.h"



@interface FindAddressViewController : UIViewController <GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UITextField* m_txtAddress;
@property (nonatomic, weak) IBOutlet UIButton* m_btnBack;
@property (nonatomic, weak) IBOutlet GMSMapView* m_mapView;
@property (nonatomic, weak) IBOutlet UITableView* m_locationTable;
@property (nonatomic, weak) IBOutlet UIView* m_listView;
@property (nonatomic, weak) IBOutlet UIButton* m_btnNearestLocation;
@property (nonatomic, weak) IBOutlet UIButton* m_btnAirport;
@property (nonatomic, weak) IBOutlet UIButton* m_btnFavourite;


@property (nonatomic, weak) BookNowViewController* bookNowVC;
@property (nonatomic) enum AddressType addressType;
@property (nonatomic) CLLocationManager* locationManager;

-(IBAction)onBack:(id)sender;
-(IBAction)onNearButton:(id)sender;
-(IBAction)onAirportButton:(id)sender;
-(IBAction)onFavoriteButton:(id)sender;
-(IBAction)onCallButton:(id)sender;
-(IBAction)onSearch:(id)sender;
-(IBAction)onAddressChanged:(id)sender;
@end
