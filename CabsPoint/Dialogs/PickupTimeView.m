//
//  PickupTimeView.m
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "PickupTimeView.h"


@implementation PickupTimeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(IBAction)onSave:(id)sender
{
    [self.delegate onSaveTime];
}
-(IBAction)onCancel:(id)sender
{
    [self.delegate onCancelTime];
}
@end
