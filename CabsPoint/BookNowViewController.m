//
//  BookNowViewController.m
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "BookNowViewController.h"
#import "PickupTimeView.h"
#import "FindAddressViewController.h"
#import "PaymentMethodViewController.h"
#import "QuoteViewController.h"
#import "BookingInformation.h"

@interface BookNowViewController ()

@end

@implementation BookNowViewController
{
    PickupTimeView* pickupTimeView;
    PassengerView* passengerView;
    SuitcaseView* suitcaseView;
    NotesView* notesView;
    UITapGestureRecognizer* tapGesture;
    BOOL hasViaAddress;
}

@synthesize m_btnDrop, m_btnPassengers, m_btnPickup, m_btnSuitcase, m_btnTime, m_btnVia, m_txtNotes, m_btnContinue, m_btnViaAddress, m_btnDel;

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
    
    hasViaAddress = false;
    self.bookInfo = [[BookingInformation alloc] init];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    [m_txtNotes.superview addGestureRecognizer:tapGesture];
    
    m_btnDrop.layer.cornerRadius = 3;
    m_btnDrop.layer.borderWidth = 1;
    m_btnDrop.layer.borderColor = [UIColor blackColor].CGColor;
    
    m_btnPassengers.layer.cornerRadius = 3;
    m_btnPassengers.layer.borderWidth = 1;
    m_btnPassengers.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    m_btnPickup.layer.cornerRadius = 3;
    m_btnPickup.layer.borderWidth = 1;
    m_btnPickup.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    m_btnSuitcase.layer.cornerRadius = 3;
    m_btnSuitcase.layer.borderWidth = 1;
    m_btnSuitcase.layer.borderColor = [UIColor blackColor].CGColor;
    
    m_btnTime.layer.cornerRadius = 3;
    m_btnTime.layer.borderWidth = 1;
    m_btnTime.layer.borderColor = [UIColor blackColor].CGColor;
    
    m_btnVia.layer.cornerRadius = 3;
    m_btnVia.layer.borderWidth = 1;
    m_btnVia.layer.borderColor = [UIColor blackColor].CGColor;
    

    m_btnDel.layer.cornerRadius = 3;
    m_btnDel.layer.borderWidth = 1;
    m_btnDel.layer.borderColor = [UIColor blackColor].CGColor;
    
    m_btnViaAddress.layer.cornerRadius = 3;
    m_btnViaAddress.layer.borderWidth = 1;
    m_btnViaAddress.layer.borderColor = [UIColor blackColor].CGColor;
}

-(void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    if(notesView == nil)
    {
        UINib *nib = [UINib nibWithNibName:@"NotesView" bundle:nil];
        notesView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [notesView setDelegate:self];
        
        [notesView.m_contentView.layer setCornerRadius:2];
        [notesView.m_contentView.layer setBorderWidth:1];
        [notesView.m_contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        [notesView.m_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
        [notesView.m_contentView.layer setShadowOpacity:0.8];
        [notesView.m_contentView.layer setShadowRadius:3.0];
        [notesView.m_contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    }
    
    notesView.frame = self.view.frame;
    [self.view addSubview:notesView];
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

-(IBAction)onVia:(id)sender
{
    if(hasViaAddress == false)
    {
        hasViaAddress = !hasViaAddress;
        self.m_btnDel.hidden = NO;
        self.m_btnViaAddress.hidden = NO;
        CGRect orgFrame = self.m_btnDrop.frame;
        self.m_btnDrop.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y + 43, orgFrame.size.width, orgFrame.size.height);
        orgFrame = self.m_firstSectionView.frame;
        self.m_firstSectionView.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y, orgFrame.size.width, orgFrame.size.height + 43);
        orgFrame = self.m_secondSecionView.frame;
        self.m_secondSecionView.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y + 43, orgFrame.size.width, orgFrame.size.height);
        orgFrame = self.m_thirdSectionView.frame;
        self.m_thirdSectionView.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y + 43, orgFrame.size.width, orgFrame.size.height);
        orgFrame = self.m_btnContinue.frame;
        self.m_btnContinue.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y + 43, orgFrame.size.width, orgFrame.size.height);
    }else
        return;
    
}
-(IBAction)onDel:(id)sender
{
    hasViaAddress = !hasViaAddress;
    self.m_btnDel.hidden = YES;
    self.m_btnViaAddress.hidden = YES;
    CGRect orgFrame = self.m_btnDrop.frame;
    self.m_btnDrop.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y - 43, orgFrame.size.width, orgFrame.size.height);
    orgFrame = self.m_firstSectionView.frame;
    self.m_firstSectionView.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y, orgFrame.size.width, orgFrame.size.height - 43);
    orgFrame = self.m_secondSecionView.frame;
    self.m_secondSecionView.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y - 43, orgFrame.size.width, orgFrame.size.height);
    orgFrame = self.m_thirdSectionView.frame;
    self.m_thirdSectionView.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y - 43, orgFrame.size.width, orgFrame.size.height);
    orgFrame = self.m_btnContinue.frame;
    self.m_btnContinue.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y - 43, orgFrame.size.width, orgFrame.size.height);}

-(IBAction)onPickupTime:(id)sender
{
    if(pickupTimeView == nil)
    {
        UINib *nib = [UINib nibWithNibName:@"PickupTimeView" bundle:nil];
        pickupTimeView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [pickupTimeView setDelegate:self];
        
        [pickupTimeView.m_contentView.layer setCornerRadius:2];
        [pickupTimeView.m_contentView.layer setBorderWidth:1];
        [pickupTimeView.m_contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        [pickupTimeView.m_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
        [pickupTimeView.m_contentView.layer setShadowOpacity:0.8];
        [pickupTimeView.m_contentView.layer setShadowRadius:3.0];
        [pickupTimeView.m_contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    }
    
    pickupTimeView.frame = self.view.frame;
    [self.view addSubview:pickupTimeView];
    
}

-(IBAction)onPickupAddress:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FindAddressViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"FindAddressViewController"];
    [controller setBookNowVC:self];
    [controller setAddressType:PICKUP_ADDRESS];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)onViaAddress:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FindAddressViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"FindAddressViewController"];
    [controller setBookNowVC:self];
    [controller setAddressType:VIA_ADDRESS];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)onDropAddress:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FindAddressViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"FindAddressViewController"];
    [controller setBookNowVC:self];
    [controller setAddressType:DROP_ADDRESS];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)onPassenger:(id)sender
{
    if(passengerView == nil)
    {
        UINib *nib = [UINib nibWithNibName:@"PassengerView" bundle:nil];
        passengerView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [passengerView setDelegate:self];
        
        [passengerView.m_contentView.layer setCornerRadius:2];
        [passengerView.m_contentView.layer setBorderWidth:1];
        [passengerView.m_contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        [passengerView.m_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
        [passengerView.m_contentView.layer setShadowOpacity:0.8];
        [passengerView.m_contentView.layer setShadowRadius:3.0];
        [passengerView.m_contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    }
    
    passengerView.frame = self.view.frame;
    [self.view addSubview:passengerView];
}
-(IBAction)onSuitcase:(id)sender
{
    if(suitcaseView == nil)
    {
        UINib *nib = [UINib nibWithNibName:@"SuitcaseView" bundle:nil];
        suitcaseView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [suitcaseView setDelegate:self];
        
        [suitcaseView.m_contentView.layer setCornerRadius:2];
        [suitcaseView.m_contentView.layer setBorderWidth:1];
        [suitcaseView.m_contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        [suitcaseView.m_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
        [suitcaseView.m_contentView.layer setShadowOpacity:0.8];
        [suitcaseView.m_contentView.layer setShadowRadius:3.0];
        [passengerView.m_contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    }
    
    suitcaseView.frame = self.view.frame;
    [self.view addSubview:suitcaseView];
}
-(IBAction)onNote:(id)sender
{
    if(notesView == nil)
    {
        UINib *nib = [UINib nibWithNibName:@"NotesView" bundle:nil];
        notesView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [notesView setDelegate:self];
        
        [notesView.m_contentView.layer setCornerRadius:2];
        [notesView.m_contentView.layer setBorderWidth:1];
        [notesView.m_contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        [notesView.m_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
        [notesView.m_contentView.layer setShadowOpacity:0.8];
        [notesView.m_contentView.layer setShadowRadius:3.0];
        [notesView.m_contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    }
    
    notesView.frame = self.view.frame;
    [self.view addSubview:notesView];
}

-(void)onNotesOK:(BOOL)childSeat WheelChair:(BOOL)wheelChair PetFriendly:(BOOL)petFriendly Note:(NSString *)note;
{
    [notesView removeFromSuperview];
    BOOL oneAdded = false;
    NSString* comment = @"";
    if(childSeat)
    {
        comment = [comment stringByAppendingString:@"Child Seat"];
        oneAdded = true;
    }
    if(wheelChair)
    {
        if(oneAdded)
            comment = [comment stringByAppendingString:@", Child Seat"];
        else
            comment = [comment stringByAppendingString:@"Child Seat"];
        oneAdded = true;
    }
    if(petFriendly)
    {
        if(oneAdded)
            comment = [comment stringByAppendingString:@", Pet Friendly"];
        else
            comment = [comment stringByAppendingString:@"Pet Friendly"];
    }
    
    if(note.length > 0)
    {
        if(oneAdded)
            comment = [comment stringByAppendingFormat:@", %@", note];
        else
            comment = [comment stringByAppendingString:note];
    }
    self.bookInfo.comment = notesView.m_txtComment.text;
    self.bookInfo.hasChildSeat = childSeat;
    self.bookInfo.hasWheelChair = wheelChair;
    self.bookInfo.isPetFriendly = petFriendly;
    self.m_txtNotes.text  = comment;
}
-(void)onNotesCancel
{
    [notesView removeFromSuperview];
}
-(void)onSuitcasesSelected:(int)index
{
    [suitcaseView removeFromSuperview];
    [m_btnSuitcase setTitle:[NSString stringWithFormat:@" %d Suitcases", index] forState:UIControlStateNormal];
    self.bookInfo.suitcaseCount = index;
}
-(void)onPassengerSelected:(int)index
{
    [passengerView removeFromSuperview];
    if(index == 0)
    {
        [m_btnPassengers setTitle:@" Upto 4 Passengers" forState:UIControlStateNormal];
        self.bookInfo.passengerCount = 4;
    }else if(index == 1)
    {
        [m_btnPassengers setTitle:@" Upto 6 Passengers" forState:UIControlStateNormal];
        self.bookInfo.passengerCount = 6;
    }else if(index == 2)
    {
        [m_btnPassengers setTitle:@" Upto 8 Passengers" forState:UIControlStateNormal];
        self.bookInfo.passengerCount = 8;
    }else if(index == 3)
    {
        [m_btnPassengers setTitle:@" Executive Car" forState:UIControlStateNormal];
        self.bookInfo.passengerCount = 10;
    }
}
-(void)onCancelTime
{
    [pickupTimeView removeFromSuperview];
}

-(void)onSaveTime
{
    if([pickupTimeView.m_radioButton isSelected])
    {
        self.bookInfo.isASAP = true;
        [m_btnTime setTitle:@" Time: ASAP" forState:UIControlStateNormal];
        //m_btnTime.titleLabel.text = @" Time: ASAP";
    }
    else
    {
        self.bookInfo.isASAP = false;
        self.bookInfo.pickupDateTime = pickupTimeView.m_datePicker.date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy, hh:mm"];
        NSString* stringFromDate = [formatter stringFromDate:self.bookInfo.pickupDateTime];
        [m_btnTime setTitle:[NSString stringWithFormat:@" Time: %@", stringFromDate] forState:UIControlStateNormal];
        //m_btnTime.titleLabel.text = [NSString stringWithFormat:@" Time: %@", stringFromDate];
    }
    [pickupTimeView removeFromSuperview];
}

-(IBAction)onContinue:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuoteViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"QuoteViewController"];
    controller.bookInfo = self.bookInfo;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)setPickupAddress:(NSString*)address PostCode:(NSString*)postCode
{
    self.bookInfo.pickupAddress1 = address;
    self.bookInfo.pickupPostCode = postCode;
    [m_btnPickup setTitle:[NSString stringWithFormat:@" Pikcup: %@", address] forState:UIControlStateNormal];
}
-(void)setViaAddress:(NSString*)address PostCode:(NSString*)postCode
{
    self.bookInfo.viaAddress1 = address;
    self.bookInfo.viaPostCode = postCode;
    [m_btnViaAddress setTitle:[NSString stringWithFormat:@" Via: %@", address] forState:UIControlStateNormal];
}
-(void)setDropAddress:(NSString*)address PostCode:(NSString*)postCode
{
    self.bookInfo.dropAddress1 = address;
    self.bookInfo.dropPostCode = postCode;
    [m_btnDrop setTitle:[NSString stringWithFormat:@" Drop: %@", address] forState:UIControlStateNormal];
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

@end
