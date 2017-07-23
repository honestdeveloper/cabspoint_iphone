//
//  NotesView.h
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotesViewProtocol <NSObject>

-(void)onNotesCancel;
-(void)onNotesOK:(BOOL)childSeat WheelChair:(BOOL)wheelChair PetFriendly:(BOOL)petFriendly Note:(NSString*)note;

@end

@class CTCheckbox;

@interface NotesView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CTCheckbox *m_chkChildSeat;
@property (weak, nonatomic) IBOutlet CTCheckbox *m_chkWheelChair;
@property (weak, nonatomic) IBOutlet CTCheckbox *m_chkPetFriendly;
@property (weak, nonatomic) IBOutlet UITextField *m_txtComment;

@property (nonatomic, weak) id<NotesViewProtocol> delegate;
@property (nonatomic, weak) IBOutlet UIView* m_contentView;

-(IBAction)onSave:(id)sender;
-(IBAction)onCancel:(id)sender;

@end
