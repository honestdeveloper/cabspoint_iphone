//
//  MyProfileViewController.h
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyProfileViewController : UIViewController <NSURLConnectionDelegate, UIAlertViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate>


@property (weak, nonatomic) IBOutlet UITextField* m_txtName;
@property (weak, nonatomic) IBOutlet UITextField* m_txtPhone;
@property (weak, nonatomic) IBOutlet UITextField* m_txtEmail;
@property (weak, nonatomic) IBOutlet UISwitch* m_swtAccountBookings;
@property (weak, nonatomic) IBOutlet UISwitch* m_swtCashCardBookings;

-(IBAction)onCancel:(id)sender;
-(IBAction)onSave:(id)sender;
@end
