//
//  RegistrationViewController.h
//  CabsPoint
//
//  Created by Alex on 1/27/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
@class GPPSignInButton;
@class ViewController;
@class FBLoginView;

@interface RegistrationViewController : UIViewController <GPPSignInDelegate>

@property (nonatomic, weak) IBOutlet UIView* m_contentView;
@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet GPPSignInButton *signInButton;
@property (nonatomic, weak) IBOutlet FBLoginView *fbSigninButton;
@property (nonatomic, weak) ViewController* viewController;
-(IBAction)onCreateNewAccount:(id)sender;
@end
