//
//  FindAddressViewController.m
//  CabsPoint
//
//  Created by Michael on 1/18/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "FindAddressViewController.h"
#import "ConfigInfo.h"
#import "JSON.h"
#import "PlaceJSONParser.h"

@interface FindAddressViewController ()

@end

@implementation FindAddressViewController
{
    CLLocationCoordinate2D mapCenter;
    CLLocationCoordinate2D currentLocation;
    int zoomOffset;
    BOOL enableMyLocation;
    double mLatitude;
    double mLongitude;
    UIActivityIndicatorView* activityIndicator;
    NSURLConnection* urlConnection;
    NSMutableData* responseData;
    NSMutableArray* listedLocations;
    NSString* addressType;
    UIImageView* centerMarker;
    NSMutableArray* listItems;
    UIView* activityIndicatorMask;
    NSString* provider;
}

@synthesize m_btnBack, m_mapView, m_locationTable, m_txtAddress, m_listView, m_btnAirport, m_btnFavourite, m_btnNearestLocation, locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    activityIndicatorMask = [[UIView alloc] init];
    [activityIndicatorMask setBackgroundColor:[UIColor lightGrayColor]];
    
    listItems = [[NSMutableArray alloc] init];
    centerMarker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_location.png"]];
    centerMarker.center = m_mapView.center;
    centerMarker.hidden = YES;
    [m_mapView addSubview:centerMarker];
    
    addressType = @"pickup";
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];

    
    zoomOffset = 5;
    mLatitude = 51.501690392607;
    mLongitude = -0.1263427734375;
    mapCenter = CLLocationCoordinate2DMake(mLatitude, mLongitude);
    currentLocation = mapCenter;
    

    
    m_btnBack.layer.cornerRadius = 3;
    m_btnBack.layer.borderWidth = 1;
    m_btnBack.layer.borderColor = [UIColor whiteColor].CGColor;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mLatitude longitude:mLongitude zoom:[m_mapView maxZoom] - zoomOffset];
	
    //m_mapView = [GMSMapView mapWithFrame:CGRectMake(0, 45, 320, 250) camera:camera];
    [m_mapView setCamera:camera];
    [m_mapView setDelegate:self];
    [m_mapView setMyLocationEnabled:YES];
    
    // Map Types Available
    m_mapView.mapType = kGMSTypeNormal;
    //    mapView_.mapType = kGMSTypeHybrid;
    //    mapView_.mapType = kGMSTypeSatellite;
    //    mapView_.mapType = kGMSTypeTerrain;
    [m_mapView setIndoorEnabled:false];
    [m_mapView setTrafficEnabled:false];
    [m_mapView.settings setRotateGestures:false];
    [m_mapView.settings setMyLocationButton:true];
    
/*
    GMSMarker *marker = [[GMSMarker alloc] init];
    [marker setPosition:CLLocationCoordinate2DMake(-33.8683, 151.2086)];
    [marker setTitle:@"Sydney"];
    [marker setSnippet:@"Australia"]; //Description in Info Window
    
	[marker setMap:mapView];
  */
    // Change Camera Angle Animated
    //[mapView animateToViewingAngle:45];
    // Change Location Animated
    //[mapView animateToLocation:CLLocationCoordinate2DMake(-33.868, 151.208)];
    // Change Location Without Animation
    [m_mapView setCamera:[GMSCameraPosition cameraWithLatitude:mLatitude longitude:mLongitude zoom:[m_mapView maxZoom] - zoomOffset]];
    // Zoom
   // [mapView animateToZoom:12];
    // Bearing (orientation)
    //[mapView animateToBearing:0];
    
    
    [self.view addSubview:m_mapView];
    
    [self listLocation:NEAREST_LOCATION];

}
-(void)addActivityIndicator
{
    [activityIndicator startAnimating];
    [activityIndicatorMask setFrame:m_locationTable.frame];
    [activityIndicatorMask addSubview:activityIndicator];
    [m_listView addSubview:activityIndicatorMask];
    activityIndicator.frame = CGRectMake(activityIndicatorMask.frame.size.width / 2 - 25, activityIndicatorMask.frame.size.height / 2 - 25, 50, 50);
}
-(void)removeActivityIndicator
{
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [activityIndicatorMask removeFromSuperview];
}

-(void)listLocation:(int)type
{
    switch (type) {
        case SEARCH:
            if([CONFIG_INFO.prevSearchText compare:m_txtAddress.text options:NSCaseInsensitiveSearch] == NSOrderedSame )
            {
                return;
            }

            [self addActivityIndicator];
            [self fetchLocationsOfType1:@"searched_location" Type2:@"any" Type3:m_txtAddress.text];
            break;
        case NEAREST_LOCATION:
            
            [self addActivityIndicator];
            [self didTapMyLocationButtonForMapView:nil];
            
            break;
        case AIRPORT:

            [self addActivityIndicator];
            [self fetchLocationsOfType1:@"known_location" Type2:@"airport" Type3:@""];
            
            break;
        case FAVOURITE:

            [self addActivityIndicator];
            [self fetchLocationsOfType1:@"known_location" Type2:@"favourite" Type3:@""];
            break;
            
        default:
            break;
    }
}
-(void)fetchLocationsOfType1:(NSString*)locationType1 Type2:(NSString*)locationType2 Type3:(NSString*)locationType3
{
    
    NSString* post = @"";
    
    post = [post stringByAppendingFormat:@"action=%@", locationType1];
    if(locationType2.length > 0)
        post = [post stringByAppendingFormat:@"&type=%@", locationType2];
    if([locationType2 compare:@"nearest_location" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        post = [post stringByAppendingFormat:@"&lat=%f", mLatitude];
        post = [post stringByAppendingFormat:@"&lon=%f", mLongitude];
    }
    if(locationType3.length > 0)
    {
        CONFIG_INFO.prevSearchText = [locationType3 lowercaseString];
        post = [post stringByAppendingFormat:@"&search_for=%@", CONFIG_INFO.prevSearchText];
    }
    post = [post stringByAppendingFormat:@"&appid=%@", CONFIG_INFO.appID];
    post = [post stringByAppendingFormat:@"&phone=%@", CONFIG_INFO.phone];
    
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
}

-(IBAction)onSearch:(id)sender
{
    if(m_txtAddress.text.length > 0)
    {
        [self listLocation:SEARCH];
    }
}
-(IBAction)onAddressChanged:(id)sender
{
    if(m_txtAddress.text.length > 0)
    {
        [self listLocation:SEARCH];
    }
}
-(IBAction)onNearButton:(id)sender
{
    [m_btnNearestLocation setSelected:YES];
    [m_btnFavourite setSelected:NO];
    [m_btnAirport setSelected:NO];
    [self listLocation:NEAREST_LOCATION];
}
-(IBAction)onAirportButton:(id)sender
{
    [m_btnNearestLocation setSelected:NO];
    [m_btnFavourite setSelected:NO];
    [m_btnAirport setSelected:YES];
    [self listLocation:AIRPORT];
}
-(IBAction)onFavoriteButton:(id)sender
{
    [m_btnNearestLocation setSelected:NO];
    [m_btnFavourite setSelected:YES];
    [m_btnAirport setSelected:NO];
    [self listLocation:FAVOURITE];
}
-(IBAction)onCallButton:(id)sender
{
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[mapView startRendering];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[mapView stopRendering];
    [super viewDidDisappear:animated];
}


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {

    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listItems.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UILabel* locationName = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 200, 20)];
        [locationName setTag:1];
        [locationName setFont:[UIFont systemFontOfSize:13]];
        UILabel* postCode = [[UILabel alloc] initWithFrame:CGRectMake(210, 3, 90, 20)];
        [postCode setTag:2];
        [postCode setFont:[UIFont systemFontOfSize:13]];
        [postCode setTextColor:[UIColor darkGrayColor]];
        
        NSArray* items = [listItems[indexPath.row] componentsSeparatedByString:@":"];
        [locationName setText:items[0]];
        [postCode setText:items[1]];
        
        [cell.contentView addSubview:locationName];
        [cell.contentView addSubview:postCode];
        
        UIButton* editButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 0, 40, 40)];
        [editButton setTag:3];
        [editButton setTag:indexPath.row];
        [editButton setImage:[UIImage imageNamed:@"pens.png"] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(onEditButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:editButton];
    }
    NSArray* items = [listItems[indexPath.row] componentsSeparatedByString:@":"];
    UILabel* locationName = (UILabel*)[cell.contentView viewWithTag:1];
    [locationName setText:items[0]];
    UILabel* postCode = (UILabel*)[cell.contentView viewWithTag:2];
    [postCode setText:items[1]];
    
    
    //[cell.textLabel setTextAlignment:UITextAlignmentLeft];
    
    
    //[cell.textLabel setText:passengerLabels[indexPath.row]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* items = [listItems[indexPath.row] componentsSeparatedByString:@":"];
    if(self.addressType == PICKUP_ADDRESS)
    {
        [self.bookNowVC setPickupAddress:items[0] PostCode:items[1]];
    }else if(self.addressType == VIA_ADDRESS)
    {
        [self.bookNowVC setViaAddress:items[0] PostCode:items[1]];
    }else if(self.addressType == DROP_ADDRESS)
    {
        [self.bookNowVC setDropAddress:items[0] PostCode:items[1]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onEditButton:(id)sender
{
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - NSURLConnectionDelegate

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
            NSArray* array = [PlaceJSONParser parsePlaces:responseText];
            NSLog(@"%@", array);
            
            @try {
                [m_mapView clear];
                listItems = [[NSMutableArray alloc] init];
                NSString* item;
                NSString* locationName, *postalCode;
                NSMutableDictionary* hmPlace;
                double lat, lng;
                GMSMarker* marker;
                CLLocationCoordinate2D lastLatLng;
                GMSCoordinateBounds* bld;// = [[GMSCoordinateBounds alloc] initWithCoordinate:currentLocation coordinate:currentLocation];
                
                listedLocations = [[NSMutableArray alloc] init];
                
                for(int i = 0; i < array.count; i++)
                {
                    hmPlace = array[i];
                    lat = [[hmPlace objectForKey:@"lat"] doubleValue];
                    lng = [[hmPlace objectForKey:@"lng"] doubleValue];
                    locationName = [hmPlace objectForKey:@"locationName"];
                    postalCode = [hmPlace objectForKey:@"postCode"];
                    item = [NSString stringWithFormat:@"%@:%@", locationName, [postalCode uppercaseString]];
                    marker = [[GMSMarker alloc] init];
                    lastLatLng = CLLocationCoordinate2DMake(lat, lng);
                    [marker setPosition:lastLatLng];
                    [listItems addObject:item];
                    marker.title = item;
                    
                    if(i == 0)
                        bld = [[GMSCoordinateBounds alloc] initWithCoordinate:lastLatLng coordinate:lastLatLng];
                    bld = [bld includingCoordinate:lastLatLng];
                    if([addressType compare:@"pickup" options:NSCaseInsensitiveSearch] == NSOrderedSame && [m_btnNearestLocation isSelected])
                    {
                        [marker setMap:m_mapView];
                        [listedLocations addObject:marker];
                    }else
                    {
                        [marker setMap:m_mapView];
                    }
                }
                
                if([addressType compare:@"pickup" options:NSCaseInsensitiveSearch] == NSOrderedSame && [m_btnNearestLocation isSelected])
                {
                    [self drawNearestLocation];
                }else
                {
                    centerMarker.hidden = NO;
                    //[m_mapView moveCamera:[GMSCameraUpdate fitBounds:bld withPadding:30.0]];
                    [m_mapView moveCamera:[GMSCameraUpdate fitBounds:bld withPadding:30.0f]];
                    //[m_mapView setCamera:[m_mapView cameraForBounds:bld insets:UIEdgeInsetsMake(0, 30, 0, 0)]];
                }
                
                [m_locationTable reloadData];
                [self removeActivityIndicator];
            }
            @catch (NSException *exception) {
                [self removeActivityIndicator];
                NSLog(@"%@", exception);
            }

        }else
        {
            [self removeActivityIndicator];
        }
    }
}

-(void)drawNearestLocation
{
    if([addressType compare:@"pickup" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        CLLocation *selectedPosition = [[CLLocation alloc] initWithLatitude:m_mapView.camera.target.latitude longitude:m_mapView.camera.target.longitude];
       
        CLLocation* dest;
        GMSMarker* nearest = nil, *marker;
        int distance = 99999999;
        int tmpDist;
        for(int i = 0; i < listedLocations.count; i++)
        {
            marker = listedLocations[i];
            // info window
            
            //marker setIcon:[m_mapView def]
            dest = [[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];
            tmpDist = (int)[selectedPosition distanceFromLocation:dest];
            if(tmpDist < distance)
            {
                distance = tmpDist;
                nearest = listedLocations[i];
            }
        }
        if(nearest != nil)
        {
            [nearest setIcon:[GMSMarker markerImageWithColor:[UIColor greenColor]]];
            // show Info window
        }
    }
}

-(void)getCurrentLocation
{
    
    //currentLocation = CLLocationCoordinate2DMake(mLatitude, mLongitude);
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

#pragma mark - Location Manager
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didfailWithError: %@",error);
    //UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Failed to get your location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    CLLocation* curLocation = newLocation;
    
    if(curLocation != nil)
    {
        currentLocation = curLocation.coordinate;
    
        mLatitude = currentLocation.latitude;
        mLongitude = currentLocation.longitude;
        mapCenter = currentLocation;
        
        [m_mapView setCamera:[GMSCameraPosition cameraWithLatitude:mapCenter.latitude longitude:mapCenter.longitude zoom:[m_mapView maxZoom] - zoomOffset]];
        [m_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:mapCenter.latitude longitude:mapCenter.longitude zoom:[m_mapView maxZoom] - zoomOffset]];
        //[self drawNearestLocation];
        
        if(![activityIndicator isAnimating])
        {
            [self addActivityIndicator];
        }
        [self drawNearestLocation];
        [self fetchLocationsOfType1:@"nearest_location" Type2:@"nearest_location" Type3:@""];
    }
    [locationManager stopUpdatingLocation];
}

#pragma mark - Map View

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
    if(self.addressType != PICKUP_ADDRESS && mapView == nil)
    {
        [self fetchLocationsOfType1:@"nearest_location" Type2:@"nearest_location" Type3:@""];
        return false;
    }
    
    [self getCurrentLocation];
    
    
    
    return false;
}
@end
