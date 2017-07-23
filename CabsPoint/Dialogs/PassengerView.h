//
//  PassengerView.h
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassengerViewProtocol <NSObject>

-(void)onPassengerSelected:(int)index;

@end

@interface PassengerView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIView* m_contentView;
@property (nonatomic, weak) IBOutlet UITableView* m_tableView;
@property (nonatomic, weak) id<PassengerViewProtocol> delegate;

@end
