//
//  PickupTimeView.h
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@protocol PickupTimeViewDelegate <NSObject>

-(void)onCancelTime;
-(void)onSaveTime;

@end
@interface PickupTimeView : UIView

@property (nonatomic, weak) IBOutlet RadioButton* m_radioButton;

@property (nonatomic, weak) IBOutlet UIView* m_contentView;
@property (nonatomic, weak) IBOutlet UIDatePicker* m_datePicker;
@property (nonatomic, weak) id<PickupTimeViewDelegate> delegate;

-(IBAction)onSave:(id)sender;
-(IBAction)onCancel:(id)sender;
@end
