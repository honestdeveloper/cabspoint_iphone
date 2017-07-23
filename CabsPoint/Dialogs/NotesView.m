//
//  NotesView.m
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import "NotesView.h"
#import "CTCheckBox.h"

@implementation NotesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.m_chkChildSeat addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    self.m_chkChildSeat.textLabel.text = @"Child Seat";
    [self.m_chkChildSeat setColor:[UIColor blackColor] forControlState:UIControlStateNormal];
    [self.m_chkChildSeat setColor:[UIColor grayColor] forControlState:UIControlStateDisabled];
    
    [self.m_chkWheelChair addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    self.m_chkWheelChair.textLabel.text = @"Wheel Chair";
    [self.m_chkWheelChair setColor:[UIColor blackColor] forControlState:UIControlStateNormal];
    [self.m_chkWheelChair setColor:[UIColor grayColor] forControlState:UIControlStateDisabled];
    
    [self.m_chkPetFriendly addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    self.m_chkPetFriendly.textLabel.text = @"Pet Friendly";
    [self.m_chkPetFriendly setColor:[UIColor blackColor] forControlState:UIControlStateNormal];
    [self.m_chkPetFriendly setColor:[UIColor grayColor] forControlState:UIControlStateDisabled];
    //[self checkboxDidChange:self.m_chkChildSeat];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    self.m_contentView.frame = CGRectMake(6, 50, 307, 360);
    CGPoint upPoint = self.m_contentView.center;
    upPoint.y -= 136;
    self.m_contentView.center = upPoint;
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.m_contentView.frame = CGRectMake(6, 104, 307, 360);
    self.m_contentView.center = self.center;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)checkboxDidChange:(CTCheckbox *)checkbox
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

-(IBAction)onSave:(id)sender
{
    [self.delegate onNotesOK:self.m_chkChildSeat.checked WheelChair:self.m_chkWheelChair.checked PetFriendly:self.m_chkPetFriendly.checked Note:self.m_txtComment.text];
    
}
-(IBAction)onCancel:(id)sender
{
    [self.delegate onNotesCancel];
}

@end
