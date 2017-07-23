//
//  InformationViewController.m
//  CabsPoint
//
//  Created by Alex on 1/27/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end


@implementation InformationViewController

@synthesize m_contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [m_contentView.layer setCornerRadius:2];
    [m_contentView.layer setBorderWidth:1];
    [m_contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [m_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
    [m_contentView.layer setShadowOpacity:0.8];
    [m_contentView.layer setShadowRadius:3.0];
    [m_contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)onOK:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
