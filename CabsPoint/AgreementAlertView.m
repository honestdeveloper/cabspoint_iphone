//
//  AgreementAlertView.m
//  CabsPoint
//
//  Created by Michael on 1/16/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "AgreementAlertView.h"

@implementation AgreementAlertView
{
    UILabel* alertTextLabel;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)init
{
    //self = [super initWithTitle:@"Term Of Use" message:@"By Clicking the 'I Agree' button you the customer confirm that you have read and agree to the Terms of Trading being incorportated in and forming prt of every contract for service" delegate:self cancelButtonTitle:@"I Agree" otherButtonTitles:nil, nil];
    self = [super init];
    if(self)
    {
        alertTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        alertTextLabel.textColor = [UIColor blackColor];
        alertTextLabel.font = [UIFont systemFontOfSize:13];
        alertTextLabel.text = @"By Clicking the 'I Agree' button you the customer confirm that you have read and agree to the Terms of Trading being incorportated in and forming prt of every contract for service";
        [alertTextLabel sizeToFit];
        [self addSubview:alertTextLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
