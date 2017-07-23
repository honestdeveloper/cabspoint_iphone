//
//  BookNowViewController.h
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickupTimeView.h"
#import "PassengerView.h"
#import "SuitcaseView.h"
#import "NotesView.h"
#import "BookingInformation.h"

enum AddressType {
    PICKUP_ADDRESS,
    DROP_ADDRESS,
    VIA_ADDRESS
};

@interface BookNowViewController : UIViewController <UIGestureRecognizerDelegate, PickupTimeViewDelegate, PassengerViewProtocol, SuitcaseViewProtocol, NotesViewProtocol>

@property (nonatomic, weak) IBOutlet UIButton* m_btnPickup;
@property (nonatomic, weak) IBOutlet UIButton* m_btnVia;
@property (nonatomic, weak) IBOutlet UIButton* m_btnDrop;
@property (nonatomic, weak) IBOutlet UIButton* m_btnTime;
@property (nonatomic, weak) IBOutlet UIButton* m_btnPassengers;
@property (nonatomic, weak) IBOutlet UIButton* m_btnSuitcase;
@property (nonatomic, weak) IBOutlet UITextField* m_txtNotes;
@property (nonatomic, weak) IBOutlet UIView* m_firstSectionView;
@property (nonatomic, weak) IBOutlet UIView* m_secondSecionView;
@property (nonatomic, weak) IBOutlet UIView* m_thirdSectionView;
@property (nonatomic, weak) IBOutlet UIButton* m_btnDel;
@property (nonatomic, weak) IBOutlet UIButton* m_btnViaAddress;
@property (nonatomic, weak) IBOutlet UIButton* m_btnContinue;
@property (nonatomic) BookingInformation* bookInfo;

-(IBAction)onBack:(id)sender;
-(IBAction)onPickupTime:(id)sender;
-(IBAction)onPickupAddress:(id)sender;
-(IBAction)onDropAddress:(id)sender;
-(IBAction)onViaAddress:(id)sender;
-(IBAction)onPassenger:(id)sender;
-(IBAction)onSuitcase:(id)sender;
-(IBAction)onNote:(id)sender;
-(void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture;
-(IBAction)onContinue:(id)sender;
-(void)setPickupAddress:(NSString*)address PostCode:(NSString*)postCode;
-(void)setViaAddress:(NSString*)address PostCode:(NSString*)postCode;
-(void)setDropAddress:(NSString*)address PostCode:(NSString*)postCode;
-(IBAction)onVia:(id)sender;
-(IBAction)onDel:(id)sender;
@end
