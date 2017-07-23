//
//  RegistrationViewController.m
//  CabsPoint
//
//  Created by Alex on 1/27/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "RegistrationViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "ConfigInfo.h"
#import "MyProfileViewController.h"
#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
{
    NSString *kClientId;
    BOOL justLoggedIn;
}

@synthesize m_contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    justLoggedIn = false;
    
    [m_contentView.layer setCornerRadius:2];
    [m_contentView.layer setBorderWidth:1];
    [m_contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [m_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
    [m_contentView.layer setShadowOpacity:0.8];
    [m_contentView.layer setShadowRadius:3.0];
    [m_contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    kClientId = @"89622858931-i4lidvq61tdiort1jrl6qo51v51na1g4.apps.googleusercontent.com";
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin, // defined in GTLPlusConstants.h
                     nil];
    signIn.delegate = self;
    
    self.signInButton.style = kGPPSignInButtonStyleWide;
    
    //[signIn authenticate];
    //[signIn trySilentAuthentication];
    //[self refreshInterfaceBasedOnSignIn];

    [self.fbSigninButton setReadPermissions:@[@"public_profile", @"email"]];
    
    self.signUpButton.layer.cornerRadius = 3.0;
    self.signUpButton.clipsToBounds = YES;
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        if ([[GPPSignIn sharedInstance] authentication]) {
            CONFIG_INFO.email = [GPPSignIn sharedInstance].authentication.userEmail;
            NSLog(@"%@", [GPPSignIn sharedInstance].authentication.userEmail);
            GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
            plusService.retryEnabled = YES;
            [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
            
            
            GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
            
            [plusService executeQuery:query
                    completionHandler:^(GTLServiceTicket *ticket,
                                        GTLPlusPerson *person,
                                        NSError *error) {
                        if (error) {
                            GTMLoggerError(@"Error: %@", error);
                        } else {
                            // Retrieve the display name and "about me" text
                            
                            NSString *description = [NSString stringWithFormat:
                                                     @"%@\n%@", person.displayName,
                                                     person.aboutMe];
                            NSLog(@"%@",description);
                            NSLog(@"%@", person.emails);
                            CONFIG_INFO.name = person.displayName;
                            CONFIG_INFO.email = [GPPSignIn sharedInstance].authentication.userEmail;
                            [self dismissViewControllerAnimated:NO completion:^{
                                [self.viewController onMyProfile:nil];
                            }];
                            
                        }
                    }];
        }else
        {
            CONFIG_INFO.email = [GPPSignIn sharedInstance].userEmail;
            
            GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
            plusService.retryEnabled = YES;
            [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
            

            GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
            
            [plusService executeQuery:query
                    completionHandler:^(GTLServiceTicket *ticket,
                                        GTLPlusPerson *person,
                                        NSError *error) {
                        if (error) {
                            GTMLoggerError(@"Error: %@", error);
                        } else {
                            // Retrieve the display name and "about me" text
                            
                            NSString *description = [NSString stringWithFormat:
                                                     @"%@\n%@", person.displayName,
                                                     person.aboutMe];
                            NSLog(@"%@",description);
                            CONFIG_INFO.name = person.displayName;
                            [self dismissViewControllerAnimated:NO completion:^{
                                [self.viewController onMyProfile:nil];
                            }];
                            
                        }
                    }];
            
        }
    }
}

-(IBAction)onCreateNewAccount:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.viewController onMyProfile:nil];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - FBLoginViewDelegate

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"LOGGED IN");
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"Login"] compare:@"logged in" options:NSCaseInsensitiveSearch] != NSOrderedSame)
    {
        justLoggedIn = true;
    }else
    {
        justLoggedIn = false;
    }

    
    [[NSUserDefaults standardUserDefaults] setValue:@"logged in" forKey:@"Login"];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"LOGGED OUT");
    [[NSUserDefaults standardUserDefaults] setValue:@"logged out" forKey:@"Login"];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    /*
    self.name.text = user.first_name;
    self.middleName.text = user.middle_name;
    self.lastName.text = user.last_name;
    self.identifier.text = user.id;
    self.username.text = user.username;
    self.birthday.text = user.birthday;
    self.link.text = user.link;
     */
    if(!justLoggedIn)
        return;
    
    CONFIG_INFO.name = user.name;
    CONFIG_INFO.email = [user objectForKey:@"email"];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.viewController onMyProfile:nil];
    }];}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"OPS, FaceBook Login encountered an error --> %@" ,error);
}

@end
